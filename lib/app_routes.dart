import 'package:get/get_navigation/src/routes/get_route.dart';
import 'pages/splash_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const SplashScreen()),
  ];
}
