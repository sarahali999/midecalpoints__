import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mainscreen/homePage.dart';
import '../registration/registrationStepsScreen.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  bool _isPasswordVisible = false;
  bool isLoading = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String?> login() async {
    try {
      if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar(
          'خطأ',
          'يرجى إدخال رقم الهاتف وكلمة المرور',
          backgroundColor: Colors.red[100],
        );
        return null;
      }
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse('https://medicalpoint-api.tatwer.tech/api/Login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['error'] == false) {
          final token = jsonResponse['data']['token'];
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('token', token);

          Get.snackbar(
            'نجاح',
            'تم تسجيل الدخول بنجاح',
            backgroundColor: Color(0xFf259e9f),
          );

          return token;
        } else {
          Get.snackbar(
            'خطأ',
            jsonResponse['message'] ?? 'فشل تسجيل الدخول',
            backgroundColor: Colors.red[100],
          );
        }
      } else {
        Get.snackbar(
          'خطأ',
          'فشل الاتصال بالخادم ${response.statusCode}',
          backgroundColor: Colors.red[100],
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع',
        backgroundColor: Colors.red[100],
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffecf2f3),
                      Color(0xFFecf2f3),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Image.asset(
                    'assets/images/logo.png',
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    color: const Color(0xFf259e9f),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  _buildTitle("تسجيل الدخول"),
                  SizedBox(height: screenHeight * 0.01),
                  _buildSubtitle(
                      "مرحبا بعودتك! نحن سعداء بعودتك مرة أخرى. يرجى إدخال بياناتك لتسجيل الدخول إلى حسابك"),
                  SizedBox(height: screenHeight * 0.05),
                  _buildPhoneNumberField(),
                  SizedBox(height: screenHeight * 0.02),
                  _buildPasswordField(),
                  SizedBox(height: screenHeight * 0.02),
                  _buildAuthLinks(),
                  SizedBox(height: screenHeight * 0.03),
                  _buildLoginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        subtitle,
        style: TextStyle(
          fontSize: Get.width * 0.04,
          color: Colors.grey,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntlPhoneField(
        decoration: InputDecoration(
          labelText: 'رقم الهاتف',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: const Color(0xffecf0f1),
        ),
        initialCountryCode: 'IQ',
        controller: phoneController,
        onChanged: (phone) {
          print(phone.completeNumber);
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffecf0f1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: passwordController,
        textAlign: TextAlign.end,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          hintText: 'كلمة المرور',
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthLinks() {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            "هل نسيت كلمة السر؟",
            style: TextStyle(color: const Color(0xFf259e9f), fontSize: Get.width * 0.035),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationStepsScreen()),
            );
          },
          child: Text(
            "ليس لدي حساب، إنشاء حساب الآن",
            style: TextStyle(color: const Color(0xFf259e9f), fontSize: Get.width * 0.035),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFf259e9f),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
          final token = await login();
          if (token != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        },
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          "الدخول",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
