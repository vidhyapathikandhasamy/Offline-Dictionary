import 'package:flutter/material.dart';
import 'package:offlined_ictionary/constants/app_colors.dart';

class OnboardPage extends StatelessWidget {
  final String image;
  final String title1;
  final String title2;
  final String description;

  const OnboardPage({
    super.key,
    required this.image,
    required this.title1,
    required this.title2,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// Image Card
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.appWhite,
              ),
              children: [
                TextSpan(text: title1),
                TextSpan(
                  text: title2,
                  style: const TextStyle(color: AppColors.appPink),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.appWhite,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
