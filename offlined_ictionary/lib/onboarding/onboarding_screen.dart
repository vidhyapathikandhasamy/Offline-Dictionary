import 'package:flutter/material.dart';
import 'package:offlined_ictionary/constants/app_colors.dart';
import 'package:offlined_ictionary/onboarding/onboard_page.dart';
import 'package:offlined_ictionary/wordslist/wordslistview.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appGreen,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// PageView
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: const [
                  OnboardPage(
                    image: "assets/image/introinfo1.png",
                    title1: "Welcome to ",
                    title2: "Offline\nDictionary",
                    description:
                        "Access thousands of definitions anywhere, anytime. No internet connection required to expand your vocabulary.",
                  ),

                  OnboardPage(
                    image: "assets/image/introinfo2.png",
                    title1: "Powerful ",
                    title2: "Word Search",
                    description:
                        "Find meanings instantly with our fast and intuitive search feature.",
                  ),

                  OnboardPage(
                    image: "assets/image/introinfo3.png",
                    title1: "Improve Your ",
                    title2: "Vocabulary",
                    description:
                        "Discover new words daily and enhance your language skills.",
                  ),
                ],
              ),
            ),

            /// Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => indicator(index == currentPage),
              ),
            ),

            const SizedBox(height: 30),

            /// Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPink,
                    foregroundColor: AppColors.appWhite,
                  ),
                  onPressed: () {
                    if (currentPage < 2) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else if (currentPage == 2) {
                      // Navigate to the words list screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const Wordslistview(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Indicator Widget
  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 22 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.appWhite : Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
