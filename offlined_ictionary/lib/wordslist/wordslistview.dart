import 'package:flutter/material.dart';

class Wordslistview extends StatefulWidget {
  const Wordslistview({super.key});

  @override
  State<Wordslistview> createState() => _WordslistviewState();
}

class _WordslistviewState extends State<Wordslistview> {
  final TextEditingController _searchController = TextEditingController();

  /// Example word list. Replace these with your real dictionary words.
  final List<String> _allWords = [
    'abate',
    'aberration',
    'abhor',
    'benevolent',
    'candid',
    'daunt',
    'eclectic',
    'facetious',
    'garrulous',
    'hapless',
    'iconoclast',
    'jovial',
    'keen',
    'laconic',
    'magnanimous',
    'nebulous',
    'obstinate',
    'palpable',
    'quaint',
    'ravenous',
    'sagacious',
    'taciturn',
    'ubiquitous',
    'venerable',
    'whimsical',
    'xenial',
    'yonder',
    'zealous',
  ];

  List<String> _filteredWords = [];

  @override
  void initState() {
    super.initState();
    _filteredWords = List.from(_allWords);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredWords = List.from(_allWords);
      } else {
        _filteredWords = _allWords
            .where((word) => word.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search words...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: _filteredWords.isEmpty
                  ? const Center(
                      child: Text(
                        'No words found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredWords.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final word = _filteredWords[index];
                        return ListTile(
                          title: Text(word),
                          onTap: () {
                            // TODO: Navigate to word detail screen.
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
