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
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
      Get.off(() => const OnboardingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      const AppLogo(),
                      const SizedBox(height: 24),
                      const AppTitle(),
                      const Spacer(flex: 2),
                      const FooterText(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate logo size based on screen width, with a maximum size
    double screenWidth = MediaQuery.of(context).size.width;
    double logoSize = screenWidth * 0.25;
    // Ensure logo doesn't get too large on wide screens
    logoSize = logoSize.clamp(50.0, 150.0);
    double iconSize = logoSize * 0.8;

    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Image(
            image: const AssetImage('assets/images/logo.png'),
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate font size with minimum and maximum bounds
    double fontSize = (screenWidth * 0.08).clamp(20.0, 40.0);

    return Text(
      'طب الحشود',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    );
  }
}

class FooterText extends StatelessWidget {
  const FooterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate font size with minimum and maximum bounds
    double fontSize = (screenWidth * 0.04).clamp(14.0, 24.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'معاونية شؤون الطلبة والمقاتلين والمضحين',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}