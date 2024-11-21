import 'package:flutter/material.dart';
import 'about.dart';
import 'delete_account.dart';
import 'edit_language.dart';
import 'on_off_notifications.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 60),
          _buildSettingsOption(
            icon: Icons.language,
            title: 'اللغة',
            trailingText: 'العربية',
            onTap: () => _showLanguageDialog(context),
          ),
          SizedBox(height: 20),
          _buildSettingsOption(
            icon: Icons.person,
            title: 'حذف الحساب',
            onTap: () => _showDeleteAccountDialog(context),
          ),
          SizedBox(height: 20),
          _buildSettingsOption(
            icon: Icons.notifications,
            title: 'السماح بالإشعارات',
            onTap: () => _showNotificationsDialog(context),
          ),
          SizedBox(height: 20),
          _buildSettingsOption(
            icon: Icons.help_outline,
            title: 'الشروط والخدمة',
            onTap: () => _showAboutDialog(context),
          ),
          Spacer(),
          _buildFooterText(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color(0xFF259E9F),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'الإعدادات',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    String? trailingText,
    required Function() onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFf259e9f)),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            Icon(Icons.chevron_left, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooterText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'جميع الحقوق محفوظة معاونية الطبابة و شؤون المقاتلين و المضحين',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LanguageDialog(),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccount(),
    );
  }

  // Popup Dialog for Notifications
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NotificationsDialog(),
    );
  }

  // Popup Dialog for About
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Aboutapp(),
    );
  }
}
