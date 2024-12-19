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
  final TextEditingController _feedbackController = TextEditingController();

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
  Future<void> _showFeedbackDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.feedback_outlined,
                      color: Color(0xFF259E9F),
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'رأيك يهمنا'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF259E9F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[50],
                    border: Border.all(
                      color: Color(0xFF259E9F).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب ملاحظاتك'.tr,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _feedbackController.clear();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          color: Color(0xFF259E9F),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: () async {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF259E9F),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'ارسال'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> _submitFeedback() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final jwtToken = prefs.getString('token');
  //
  //     if (jwtToken != null) {
  //       final response = await http.post(
  //         Uri.parse('https://medicalpoint-api.tatwer.tech/api/Mobile/SubmitFeedback'),
  //         headers: {
  //           'Authorization': 'Bearer $jwtToken',
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({
  //           'feedback': _feedbackController.text,
  //         }),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('feedback_submitted'.tr),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //       } else {
  //         throw Exception('Failed to submit feedback');
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('error_submitting_feedback'.tr),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text('cancel'.tr,style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
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
        body: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 20),
              _buildSettingsOption(
                icon: Icons.dangerous,
                title: 'delete_account'.tr,
                onTap: () => _showDeleteAccountDialog(context),
              ),
              SizedBox(height: 20),
              _buildFooterText(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showFeedbackDialog,
          backgroundColor: Color(0xFF259E9F),
          child: Icon(Icons.feedback,color: Colors.white,),
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
              ? Colors.red
              : Color(0xFf259e9f),
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
      {'code': 'ur', 'name': 'اُرْدُوْ'},
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