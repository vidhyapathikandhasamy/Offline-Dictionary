import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offlined_ictionary/constants/app_fonts.dart';
import 'package:offlined_ictionary/onboarding/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      home: OnboardingScreen(),
    );
  }
}
