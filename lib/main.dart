import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import 'languages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Cairo',
      ),
      translations: Languages(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      title: 'My App',
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}