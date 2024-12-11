import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:midecalpoints/mainscreen/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../languages.dart';
import '../login/verification.dart';
import 'about.dart';
import 'delete_account.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 32),
              SizedBox(width: 15),
              Text(
                'logout'.tr,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'confirm_logout'.tr,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('cancel'.tr),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                'logout'.tr,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Get.offAll(() => Login());
              },
            ),
          ],
        );

      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            SizedBox(height: 60),
            _buildSettingsOption(
              icon: Icons.language,
              title: 'language'.tr,
              trailingText: 'language'.tr,
              onTap: () => _showLanguageDialog(context),
            ),
            SizedBox(height: 20),
            _buildNotificationOption(),
            SizedBox(height: 20),
            _buildSettingsOption(
              icon: Icons.person,
              title: 'user_information'.tr,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile()
                  )
              ),
            ),
            SizedBox(height: 20),
            _buildSettingsOption(
              icon: Icons.help_outline,
              title: 'terms_and_service'.tr,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Aboutapp()
                )
              ),
            ),
            SizedBox(height: 20),
            _buildSettingsOption(
              icon: Icons.logout,
              title: 'logout'.tr,
              onTap: _logout,
            ),
            Spacer(),
            Spacer(),
            _buildSettingsOption(
              icon: Icons.dangerous,
              title: 'delete_account'.tr,
              onTap: () => _showDeleteAccountDialog(context),
            ),
            Spacer(),
            _buildFooterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOption() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
          color: Color(0xFf259e9f),
        ),
        title: Text(
          'notifications'.tr,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: _toggleNotifications,
          activeColor: Color(0xFf259e9f),
        ),
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
        'settings'.tr,
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
        leading: Icon(
          icon,
          color: icon == Icons.logout || icon == Icons.dangerous
              ? Colors.red // هنا قمت بتغيير اللون إلى الأحمر فقط للأيقونات المطلوبة
              : Color(0xFf259e9f), // لترك الألوان الأخرى كما هي
        ),
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
        'all_rights_reserved'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }
  void _showLanguageDialog(BuildContext context) {
    final List<Map<String, String>> languages = [
      {'code': 'ar', 'name': 'العربية'},
      {'code': 'en', 'name': 'English'},
      {'code': 'fa', 'name': 'فارسی'},
      {'code': 'ku', 'name': 'کوردی'},
      {'code': 'tk', 'name': 'تركماني'},
    ];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder<String?>(
              future: _getCurrentLanguage(),
              builder: (context, snapshot) {
                String? selectedLanguage = snapshot.data ?? '';
                return Directionality(
                  textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: AlertDialog(
                    title: Text(
                      'language'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF259E9F),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: languages.map((language) {
                        bool isSelected = selectedLanguage == language['code'];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF259E9F).withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              language['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Color(0xFF259E9F)
                                    : Colors.black,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check, color: Color(0xFF259E9F))
                                : null,
                            onTap: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              await prefs.setString('language', language['code']!);
                              Get.updateLocale(Locale(language['code']!));
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(color: Color(0xFF259E9F)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  Future<String?> _getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccount(),
    );
  }
}
