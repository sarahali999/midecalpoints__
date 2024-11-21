import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

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
      title: 'My App',
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}
