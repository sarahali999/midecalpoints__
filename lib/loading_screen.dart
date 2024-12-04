import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final VoidCallback onLoaded;

  const LoadingScreen({Key? key, required this.onLoaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      onLoaded();
    });
    return Scaffold(
      backgroundColor:Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/lord.gif',
          width: 250.0,
          height: 250.0,
        ),
      ),
    );
  }
}
