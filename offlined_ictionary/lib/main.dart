import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offlined_ictionary/constants/app_fonts.dart';
import 'package:offlined_ictionary/onboarding/onboarding_screen.dart';
import 'package:offlined_ictionary/wordslist/wordslistview.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSeenOnboardingKey = 'seenOnboarding';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _shouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_kSeenOnboardingKey) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Dictionary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        fontFamily: AppFonts.robotoMono,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _shouldShowOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final showOnboarding = snapshot.data ?? true;
          return showOnboarding
              ? const OnboardingScreen()
              : const Wordslistview();
        },
      ),
    );
  }
}
