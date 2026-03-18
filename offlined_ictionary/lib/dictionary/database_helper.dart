import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WordEntry {
  final int id;
  final String word;
  final String pos;
  final String meaning;
  final String example;

  WordEntry({
    required this.id,
    required this.word,
    required this.pos,
    required this.meaning,
    required this.example,
  });

  factory WordEntry.fromMap(Map<String, dynamic> map) {
    return WordEntry(
      id: map['id'] as int? ?? 0,
      word: map['word'] as String? ?? '',
      pos: map['pos'] as String? ?? '',
      meaning: map['meaning'] as String? ?? '',
      example: map['example'] as String? ?? '',
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the app's documents directory
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'full_dictionary_600k.db');

    // Check if database already exists and has data
    final exists = await databaseExists(path);

    if (exists) {
      final db = await openDatabase(path);
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM sqlite_master WHERE type="table" AND name="words"',
      );
      final tableExists = ((result.first['count'] as int?) ?? 0) > 0;

      if (tableExists) {
        final wordCount = await db.rawQuery(
          'SELECT COUNT(*) as count FROM words',
        );
        final count = (wordCount.first['count'] as int?) ?? 0;
        if (count > 0) {
          // Database has data, use as is
          return openDatabase(path);
        }
      }
    }

    // Database doesn't exist or is empty, create and populate it
    final newDb = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS words (id INTEGER PRIMARY KEY, word TEXT UNIQUE, pos TEXT, meaning TEXT, example TEXT)',
        );
      },
    );

    // Populate database from JSON
    await _populateDatabaseFromJson(newDb);
    return newDb;
  }

  Future<void> _populateDatabaseFromJson(Database db) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/english_dictionary.json',
      );
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final List<dynamic> wordsJson = jsonMap['words'] as List<dynamic>? ?? [];

      // Use batch for better performance
      final batch = db.batch();

      for (final item in wordsJson) {
        final wordData = item as Map<String, dynamic>;
        batch.insert('words', {
          'word': wordData['word'] as String? ?? '',
          'pos': wordData['pos'] as String? ?? '',
          'meaning': wordData['meaning'] as String? ?? '',
          'example': wordData['example'] as String? ?? '',
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
      debugPrint('Database populated with ${wordsJson.length} words');
    } catch (e) {
      throw Exception('Error populating database from JSON: $e');
    }
  }

  Future<List<WordEntry>> getAllWords() async {
    try {
      final db = await database;
      final maps = await db.query('words');
      return List.generate(maps.length, (i) => WordEntry.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Error fetching words: $e');
    }
  }

  Future<List<WordEntry>> searchWords(String query) async {
    try {
      final db = await database;
      final maps = await db.query(
        'words',
        where: 'word LIKE ?',
        whereArgs: ['%$query%'],
        limit: 500, // Limit results for performance
      );
      return List.generate(maps.length, (i) => WordEntry.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Error searching words: $e');
    }
  }

  Future<WordEntry?> getWordByExactMatch(String word) async {
    try {
      final db = await database;
      final maps = await db.query(
        'words',
        where: 'LOWER(word) = LOWER(?)',
        whereArgs: [word],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return WordEntry.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching word: $e');
    }
  }

  Future<int> getTotalWordsCount() async {
    try {
      final db = await database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM words');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error getting word count: $e');
    }
  }

  void close() {
    _database?.close();
    _database = null;
  }
}
