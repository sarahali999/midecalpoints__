import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xfff6f6f6),
      fontFamily: 'Cairo',
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xfff6f6f6),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.black,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.black,
        ),
      ),
    );
  }
}
