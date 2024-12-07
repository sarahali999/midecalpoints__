import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../mainscreen/home_page.dart';
import 'introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    await Future.delayed(_splashDuration);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Get.offAll(() => MainScreen());
    } else {
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return Scaffold(
      backgroundColor: const Color(0xFF259E9F),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                AppLogo(screenWidth: screenWidth),
                const SizedBox(height: 16),
                AppTitle(screenWidth: screenWidth),
                const Spacer(flex: 3),
                FooterText(screenWidth: screenWidth),
                SizedBox(height: screenHeight * 0.04),
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
    final double logoSize = (screenWidth * 0.35).clamp(70.0, 150.0);
    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
          color: Colors.white,
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
    final double fontSize = (screenWidth * 0.09).clamp(20.0, 32.0);
    return Text(
      'طب الحشود',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  final double screenWidth;
  const FooterText({Key? key, required this.screenWidth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double fontSize = (screenWidth * 0.038).clamp(12.0, 18.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'معاونية شؤون الطبابة والمقاتلين والمضحين',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}