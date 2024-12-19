import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'app_routes.dart';
import 'languages.dart';
import 'app_theme.dart';

void initializeOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("050d7df1-2374-4fb5-9b4e-a800bb099f7b");

  OneSignal.Notifications.requestPermission(true).then((accepted) {
    debugPrint("Notification permissions accepted: $accepted");
  });

  OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
    debugPrint("Notification will display: ${event.notification.title}");

    final prefs = await SharedPreferences.getInstance();
    final notificationData = {
      'title': event.notification.title ?? 'No Title',
      'body': event.notification.body ?? 'No Body',
      'image': event.notification.bigPicture,
      'timestamp': DateTime.now().toIso8601String()
    };

    List<String> notifications = prefs.getStringList('notifications') ?? [];

    bool isDuplicate = notifications.any((notification) {
      final decodedNotification = json.decode(notification) as Map<String, dynamic>;
      return decodedNotification['title'] == notificationData['title'];
    });

    if (!isDuplicate) {
      notifications.add(json.encode(notificationData));
      await prefs.setStringList('notifications', notifications);
    } else {
      debugPrint("Duplicate notification detected, skipping...");
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeOneSignal();

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
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error loading language')),
            ),
          );
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