import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'languages.dart';
import 'app_theme.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _localeFuture;

  @override
  void initState() {
    super.initState();
    _localeFuture = _loadSavedLanguage();
  }

  Future<String> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('language') ?? 'ar';
    return savedLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _localeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading language'));
        }
        final locale = snapshot.data ?? 'ar';
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          translations: Languages(),
          locale: Locale(locale),
          fallbackLocale: const Locale('ar'),
          title: 'My App',
          initialRoute: '/',
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
