import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageDialog extends StatefulWidget {
  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  final List<Map<String, String>> _languages = [
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'en', 'name': 'English'},
    {'code': 'fa', 'name': 'فارسی'},
    {'code': 'ku', 'name': 'کوردی'},
    {'code': 'tk', 'name': 'تركماني'},
  ];

  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'ar';
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);

    Locale newLocale = Locale(languageCode);
    Get.updateLocale(newLocale);

    setState(() {
      _selectedLanguage = languageCode;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'language'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF259E9F),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _languages.map((language) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _selectedLanguage == language['code']
                  ? Color(0xFF259E9F).withOpacity(0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                language['name']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedLanguage == language['code']
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedLanguage == language['code']
                      ? Color(0xFF259E9F)
                      : Colors.black,
                ),
              ),
              trailing: _selectedLanguage == language['code']
                  ? Icon(Icons.check, color: Color(0xFF259E9F))
                  : null,
              onTap: () => _changeLanguage(language['code']!),
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'cancel'.tr,
            style: TextStyle(color: Color(0xFF259E9F)),
          ),
        ),
      ],
    );
  }
}