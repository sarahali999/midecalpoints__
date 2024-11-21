import 'package:flutter/material.dart';

class LanguageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('اختيار اللغة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('العربية'),
            onTap: () {
              // Set language to Arabic
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('الإنجليزية'),
            onTap: () {
              // Set language to English
              Navigator.pop(context);
            },
          ),
          // Add more languages if needed
        ],
      ),
    );
  }
}
