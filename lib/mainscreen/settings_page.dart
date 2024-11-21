import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
          ),
          SizedBox(height: 20),

          _buildSettingsOption(
            icon: Icons.person,
            title: 'المعلومات الشخصية',
          ),
          SizedBox(height: 20),

          _buildSettingsOption(
            icon: Icons.lock,
            title: 'تغيير كلمة السر',
          ),
          SizedBox(height: 20),

          _buildSettingsOption(
            icon: Icons.notifications,
            title: 'السماح بالإشعارات',
          ),
          SizedBox(height: 20),

          _buildSettingsOption(
            icon: Icons.help_outline,
            title: 'اعرف عنا',
          ),
          Spacer(),
          _buildFooterText(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFf259e9f),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Text(
            'الإعدادات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    String? trailingText,
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
        onTap: () {
          // Handle navigation to corresponding setting page
        },
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
}
