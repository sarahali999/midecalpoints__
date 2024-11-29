import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'languages.dart';

void main() {
  runApp(

      const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('selectedLanguageCode') ?? 'ar';

    setState(() {
      _locale = Locale(savedLanguageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff6f6f6),
        fontFamily: 'Cairo',
      ),
      translations: Languages(),
      locale: _locale,
      fallbackLocale: const Locale('ar'),
      title: 'My App',
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}