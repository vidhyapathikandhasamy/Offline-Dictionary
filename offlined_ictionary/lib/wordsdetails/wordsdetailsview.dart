import 'package:flutter/material.dart';
import 'package:offlined_ictionary/constants/app_colors.dart';
import 'package:offlined_ictionary/dictionary/database_helper.dart';

class Wordsdetailsview extends StatefulWidget {
  final WordEntry wordEntry;

  const Wordsdetailsview({super.key, required this.wordEntry});

  @override
  State<Wordsdetailsview> createState() => _WordsdetailsviewState();
}

class _WordsdetailsviewState extends State<Wordsdetailsview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
        centerTitle: true,
        backgroundColor: AppColors.appGreen,
        foregroundColor: AppColors.appWhite,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Word Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.appGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.wordEntry.word,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.appGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.wordEntry.pos.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Meaning Section
              _buildSectionCard(
                title: 'Meaning',
                content: widget.wordEntry.meaning,
                icon: Icons.lightbulb_outline,
              ),

              const SizedBox(height: 16),

              // Example Section
              _buildSectionCard(
                title: 'Example',
                content: widget.wordEntry.example,
                icon: Icons.format_quote,
              ),

              const SizedBox(height: 32),

              // Action Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       // TODO: Add to favorites or other actions
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(
              //             '${widget.wordEntry.word} added to favorites!',
              //           ),
              //           backgroundColor: AppColors.appGreen,
              //         ),
              //       );
              //     },
              //     icon: const Icon(Icons.favorite_border),
              //     label: const Text('Add to Favorites'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.appGreen,
              //       foregroundColor: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.appGreen.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.appGreen, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
