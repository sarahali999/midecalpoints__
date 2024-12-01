import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mainscreen/home_page.dart';
import '../registration/registration_steps_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  bool isLoading = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isRTL = true;

  Future<String?> login() async {
    try {
      if (phoneController.text.isEmpty || passwordController.text.isEmpty) {

        print('Validation Error: Empty phone or password');
        Get.snackbar(
          'error'.tr,
          'enter_phone_password'.tr,
          backgroundColor: Colors.red[100],
        );
        return null;
      }

      setState(() {
        isLoading = true;
      });

      final requestBody = {
        'phoneNumber': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      };

      print('Request URL: https://medicalpoint-api.tatwer.tech/api/Login');
      print('Request Headers: {"Content-Type": "application/json"}');
      print('Request Body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('https://medicalpoint-api.tatwer.tech/api/Login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Parsed JSON Response: $jsonResponse');

        if (jsonResponse['error'] == false) {
          final token = jsonResponse['data']['token'];
          print('Login Successful');
          print('Token: $token');

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          print('Token saved to SharedPreferences');

          Get.snackbar(
            'success'.tr,
            'login_success'.tr ,
            colorText: Colors.white,
            backgroundColor: Color(0xFf259e9f),
          );
          return token;
        } else {
          print('Login Failed - Server Error Message: ${jsonResponse['message']}');
          Get.snackbar(
            'error'.tr,
            'login_failed'.tr,
            backgroundColor: Colors.red[100],
          );
        }
      } else {
        print('HTTP Error: Status Code ${response.statusCode}');
        print('Error Response Body: ${response.body}');

        Get.snackbar(
          'error'.tr,
          'server_error'.tr,
          backgroundColor: Colors.red[100],
        );
      }
    } catch (e, stackTrace) {
      print('Exception during login:');
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      Get.snackbar(
        'error'.tr,
        'unexpected_error'.tr,
        backgroundColor: Colors.red[100],
      );
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Login process completed - Loading state reset');
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffecf2f3),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: const Color(0xFf259e9f),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                left: 0,
                right: 0,
                bottom: Get.height * 0.3,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffecf2f3),
                        Color(0xFFecf2f3),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(0),
                      topRight: const Radius.circular(0),
                      bottomLeft: Radius.circular(Get.width * 0.3),
                      bottomRight: Radius.circular(Get.width * 10),
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
                    _buildTitle("login".tr),
                    SizedBox(height: screenHeight * 0.01),
                    _buildSubtitle("welcome_back".tr),
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
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
      textAlign: TextAlign.end,
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        fontSize: Get.width * 0.04,
        color: Colors.grey,
      ),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildPhoneNumberField() {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'phone_number'.tr,
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
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFECEFF1),
        hintText: 'password'.tr,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
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
            "forgot_password".tr,
            style: TextStyle(color: const Color(0xFf259e9f), fontSize: Get.width * 0.035),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => RegistrationStepsScreen());
          },
          child: Text(
            "no_account".tr,
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
            : Text(
          "enter".tr,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
