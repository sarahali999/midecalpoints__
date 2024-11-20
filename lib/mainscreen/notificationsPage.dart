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

    // Request notification permissions
    OneSignal.Notifications.requestPermission(true).then((accepted) {
      print("Notification permissions accepted: $accepted");
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('Notification received in foreground: ${event.notification.title} - ${event.notification.body}');
      _addNotification(event.notification);
    });

    OneSignal.Notifications.addClickListener((event) {
      print('Notification clicked: ${event.notification.body}');
      _addNotification(event.notification);
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Permission state changed: $state");
    });

    _checkStoredNotifications();
  }

  void _checkStoredNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedNotifications = prefs.getStringList('notifications');
    if (storedNotifications != null && storedNotifications.isNotEmpty) {
      print('Found stored notifications: ${storedNotifications.length}');
      _loadNotifications();
    } else {
      print('No stored notifications found');
    }
  }

  void _addNotification(OSNotification notification) {
    final Map<String, dynamic> notificationMap = {
      'title': notification.title ?? 'No Title',
      'body': notification.body ?? 'No Content',
      'additionalData': notification.additionalData,
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('Adding notification: $notificationMap');

    setState(() {
      _notifications.insert(0, notificationMap);
    });

    _saveNotifications();
  }

  void _loadNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? notificationStrings = prefs.getStringList('notifications');
      print('Loaded notifications: $notificationStrings');
      if (notificationStrings != null && notificationStrings.isNotEmpty) {
        setState(() {
          _notifications = notificationStrings
              .map((str) => json.decode(str) as Map<String, dynamic>)
              .toList();
        });
      } else {
        print('No stored notifications found');
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
    print('Notifications after loading: $_notifications');
  }

  void _saveNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> notificationStrings = _notifications.map((n) => json.encode(n)).toList();
      await prefs.setStringList('notifications', notificationStrings);
      print('Saved notifications: $notificationStrings');
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5BB9AE),
          elevation: 0,
          title: Text(
            'إشعارات صحية',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF5BB9AE), Color(0xFFBCE3F3)],
            ),
          ),
          child: _notifications.isEmpty
              ? Center(child: Text('لا توجد إشعارات حالياً', style: TextStyle(fontSize: 18)))
              : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: _notifications.length,
            itemBuilder: (BuildContext context, int index) {
              final notification = _notifications[index];
              String? imageUrl = notification['additionalData']?['image'];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ListTile(
                      title: Text(
                        notification['title'] ?? 'No Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF5BB9AE),
                        ),
                      ),
                      subtitle: Text(
                        notification['body'] ?? 'No Content',
                        style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                      trailing: Icon(Icons.notifications, color: Color(0xFF5BB9AE)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}