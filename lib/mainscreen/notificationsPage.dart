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

    _checkStoredNotifications();
  }

  void _checkStoredNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedNotifications = prefs.getStringList('notifications');
    if (storedNotifications != null && storedNotifications.isNotEmpty) {
      _loadNotifications();
    }
  }

  void _addNotification(OSNotification notification) {
    final Map<String, dynamic> notificationMap = {
      'title': notification.title ?? 'No Title',
      'body': notification.body ?? 'No Content',
      'additionalData': notification.additionalData,
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
    List<String> notificationStrings = _notifications.map((n) => json.encode(n)).toList();
    await prefs.setStringList('notifications', notificationStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5BB9AE),
          elevation: 5,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإشعارات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _loadNotifications();
                  });
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: _notifications.isEmpty
              ? Center(
            child: Text(
              'لا توجد إشعارات حالياً',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12)),
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
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(Icons.notifications,
                          color: Color(0xFF5BB9AE)),
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
