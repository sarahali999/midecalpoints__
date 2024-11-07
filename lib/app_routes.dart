// lib/app_routes.dart
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'pages/splash_screen.dart';
// استيراد صفحات إضافية هنا مثل HomeScreen

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const SplashScreen()),
    // أضف المزيد من المسارات هنا
    // GetPage(name: '/home', page: () => HomeScreen()),
  ];
}
