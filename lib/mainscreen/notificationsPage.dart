import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Publicnotices extends StatefulWidget {
  @override
  _PublicnoticesState createState() => _PublicnoticesState();
}

class _PublicnoticesState extends State<Publicnotices> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _initializeOneSignal();
  }

  void _initializeOneSignal() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("050d7df1-2374-4fb5-9b4e-a800bb099f7b");

    OneSignal.Notifications.requestPermission(true).then((accepted) {
      print("Notification permissions accepted: $accepted");
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      _addNotification(event.notification);
    });

    OneSignal.Notifications.addClickListener((event) {
      _addNotification(event.notification);
    });
  }

  void _addNotification(OSNotification notification) {
    final Map<String, dynamic> notificationMap = {
      'title': notification.title ?? 'No Title',
      'body': notification.body ?? 'No Content',
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _notifications.insert(0, notificationMap);
    });

    _saveNotifications();
  }

  void _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notificationStrings = prefs.getStringList('notifications');
    if (notificationStrings != null && notificationStrings.isNotEmpty) {
      setState(() {
        _notifications = notificationStrings
            .map((str) => json.decode(str) as Map<String, dynamic>)
            .toList();
      });
    }
  }

  void _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificationStrings =
    _notifications.map((n) => json.encode(n)).toList();
    await prefs.setStringList('notifications', notificationStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
       appBar:    AppBar(
       flexibleSpace: Container(
         decoration: BoxDecoration(
           color: Color(0xFF259E9F),
           borderRadius: BorderRadius.only(
             bottomLeft: Radius.circular(20),
             bottomRight: Radius.circular(20),
           ),
         ),
       ),
          title: Text(
            'الإشعارات',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,

          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _loadNotifications();
                });
              },
            ),
          ],
        ),
        body: _notifications.isEmpty
            ? Center(
          child: Text(
            'لا توجد إشعارات حالياً',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16),
          itemCount: _notifications.length,
          itemBuilder: (BuildContext context, int index) {
            final notification = _notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEAF8F8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Color(0xFF5BB9AE),
                  ),
                  title: Text(
                    notification['body'] ?? 'No Content',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    notification['timestamp']?.split('T').first ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}