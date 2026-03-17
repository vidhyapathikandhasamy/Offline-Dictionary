import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offlined_ictionary/constants/app_colors.dart';

class WordEntry {
  final String word;
  final String pos;
  final String meaning;
  final String example;

  WordEntry({
    required this.word,
    required this.pos,
    required this.meaning,
    required this.example,
  });

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      word: json['word'] as String? ?? '',
      pos: json['pos'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      example: json['example'] as String? ?? '',
    );
  }
}

class Wordslistview extends StatefulWidget {
  const Wordslistview({super.key});

  @override
  State<Wordslistview> createState() => _WordslistviewState();
}

class _WordslistviewState extends State<Wordslistview>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  List<WordEntry> _allWords = [];
  List<WordEntry> _filteredWords = [];

  bool _isLoading = true;
  String? _loadError;
  bool _isSearching = false;

  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _loadWords();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/english_dictionary.json',
      );
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final List<dynamic> wordsJson = jsonMap['words'] as List<dynamic>? ?? [];

      _allWords = wordsJson
          .map((item) => WordEntry.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        _filteredWords = List.from(_allWords);
        _isLoading = false;
      });

      // Trigger animation for initial load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchAnimationController.reset();
        _searchAnimationController.forward();
      });
    } catch (e, st) {
      // Log the full error and stack trace to help diagnose asset loading issues.
      debugPrint('Failed to load word list: $e');
      debugPrintStack(stackTrace: st);
      setState(() {
        _isLoading = false;
        _loadError = e.toString();
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      _isSearching = true;
    });

    // Add a small delay to show the searching animation
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        if (query.isEmpty) {
          _filteredWords = List.from(_allWords);
        } else {
          _filteredWords = _allWords
              .where((word) => word.word.toLowerCase().contains(query))
              .toList();
        }
        _isSearching = false;
      });

      // Trigger animation
      _searchAnimationController.reset();
      _searchAnimationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appGreen,
        foregroundColor: AppColors.appWhite,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
            ? Center(child: Text('Failed to load words:\n$_loadError'))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search words...',
                        hintStyle: TextStyle(
                          color: AppColors.appGreen.withValues(alpha: 0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.appGreen,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.appGreen,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.appWhite.withValues(alpha: 0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.appGreen.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.appGreen.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.appGreen,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: _filteredWords.isEmpty
                          ? Center(
                              key: const ValueKey('empty'),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: AppColors.appGreen.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No words found.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.appGreen.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try adjusting your search terms',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.appGreen.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _isSearching
                          ? Container(
                              key: const ValueKey('searching'),
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.appGreen,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Searching...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.appGreen.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              key: ValueKey('results_${_filteredWords.length}'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: _filteredWords.length,
                              itemBuilder: (context, index) {
                                final word = _filteredWords[index];
                                return AnimatedBuilder(
                                  animation: _searchAnimation,
                                  builder: (context, child) {
                                    return FadeTransition(
                                      opacity: _searchAnimation,
                                      child: SlideTransition(
                                        position:
                                            Tween<Offset>(
                                              begin: const Offset(0, 0.1),
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(
                                                parent:
                                                    _searchAnimationController,
                                                curve: Interval(
                                                  (index * 0.05).clamp(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                  ((index * 0.05) + 0.3).clamp(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                  curve: Curves.easeOut,
                                                ),
                                              ),
                                            ),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Card(
                                            elevation: 2,
                                            shadowColor: AppColors.appGreen
                                                .withValues(alpha: 0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () {
                                                // TODO: Navigate to word detail screen.
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            word.word,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  letterSpacing:
                                                                      0.5,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .appGreen
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              word.pos
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .appGreen,
                                                                letterSpacing:
                                                                    0.8,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 16,
                                                      color: AppColors.appGreen
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
