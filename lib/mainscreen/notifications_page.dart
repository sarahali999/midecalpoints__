import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../controller/user_controller.dart';
import '../languages.dart';

class Publicnotices extends StatefulWidget {
  @override
  _PublicnoticesState createState() => _PublicnoticesState();

  final UserController infoController = Get.put(UserController());
}

class _PublicnoticesState extends State<Publicnotices> {
  List<Map<String, dynamic>> _notifications = [];
  Set<int> _expandedNotifications = {};

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }
  void _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    
    final notificationStrings = prefs.getStringList('notifications') ?? [];
    print(notificationStrings);

    setState(() {
      _notifications = notificationStrings
          .map((str) => json.decode(str) as Map<String, dynamic>)
          .toList();
    });
  }

  void _deleteAllNotifiction() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationStrings = prefs.getStringList('notifications') ?? [];
    notificationStrings.clear();
    await prefs.setStringList('notifications', notificationStrings);
    setState(() {
      _notifications.clear(); // Clear the _notifications list in the UI
    });
  }


  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale?.languageCode ?? 'en';
    final isRightToLeft = Languages.isRTL(currentLocale);

    return Directionality(
      textDirection: isRightToLeft ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _notifications.isEmpty ? _buildEmptyState() : _buildNotificationList(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      flexibleSpace: _buildAppBarGradient(),
      title: Text(
        'notifications'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadNotifications,
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.white),
          onPressed: _deleteAllNotifiction,
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAppBarGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF259E9F),
            Color(0xFF1C7A7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'no_notifications'.tr,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) => _buildNotificationCard(index),
    );
  }
  Widget _buildNotificationCard(int index) {
    final notification = _notifications[index];
    final isExpanded = _expandedNotifications.contains(index);
    final fullBody = notification['body'] ?? 'no_content'.tr;
    final displayBody = isExpanded ? fullBody : _truncateText(fullBody);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isExpanded
              ? const Color(0xFF259E9F).withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => setState(() {
            if (isExpanded) {
              _expandedNotifications.remove(index);
            } else {
              _expandedNotifications.add(index);
            }
          }),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationImage(notification),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildNotificationContent(displayBody, notification, fullBody),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF259E9F)),
                  onPressed: () {
                    _deleteNotification(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }
  Widget _buildNotificationImage(Map<String, dynamic> notification) {
    final imageUrl = notification['image'];

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: imageUrl != null && imageUrl != 'No Content'
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: 80,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildNotificationIcon(),
        ),
      )
          : _buildNotificationIcon(),
    );
  }

  Widget _buildNotificationContent(String displayBody, Map<String, dynamic> notification, String fullBody) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title'] ?? 'No Title',
            style: const TextStyle(
              color: Color(0xFF259E9F),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayBody,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
            ),
            maxLines: displayBody == fullBody ? null : 2,
            overflow: displayBody == fullBody ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (fullBody.length > 100)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "المزيد",
                style: const TextStyle(
                  color: Color(0xFF259E9F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF5BB9AE).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.notifications,
          color: Color(0xFF5BB9AE),
          size: 30,
        ),
      ),
    );
  }

  String _truncateText(String text, {int maxLength = 100}) {
    return text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';
  }
}
