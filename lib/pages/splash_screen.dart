import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 7);

  @override
  void initState() {
    super.initState();
    Timer(_splashDuration, () {
      Get.off(() => const OnboardingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use GetX to access screen width and height
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                AppLogo(screenWidth: screenWidth),
                const SizedBox(height: 24),
                AppTitle(screenWidth: screenWidth),
                const Spacer(flex: 2),
                FooterText(screenWidth: screenWidth),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double screenWidth;

  const AppLogo({Key? key, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make logo size responsive
    final double logoSize = (screenWidth * 0.25).clamp(50.0, 150.0);
    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: logoSize * 0.8,
          height: logoSize * 0.8,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  final double screenWidth;

  const AppTitle({Key? key, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = (screenWidth * 0.08).clamp(20.0, 40.0);
    return Text(
      'طب الحشود',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  final double screenWidth;

  const FooterText({Key? key, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = (screenWidth * 0.04).clamp(14.0, 24.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'معاونية شؤون الطلبة والمقاتلين والمضحين',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
