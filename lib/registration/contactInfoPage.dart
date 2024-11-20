import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'custom.dart';

class ContactInfoPage extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const ContactInfoPage({
    Key? key,
    required this.phoneController,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    double spacing = screenHeight * 0.02;

    EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: spacing,
    );

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Username Field
          CustomTextField(
            labelText: 'اسم المستخدم',
            controller: usernameController,
          ),
          SizedBox(height: spacing),

          // Phone Number Field
          IntlPhoneField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: const Color(0xFFd6dedf),
            ),
            initialCountryCode: 'IQ', // Default country code
            textAlign: TextAlign.right, // RTL support
            invalidNumberMessage: 'رقم هاتف غير صالح',
            onChanged: (phone) {
              print(phone.completeNumber);
            },
          ),
          SizedBox(height: spacing),

          // Email Field
          CustomTextField(
            labelText: 'البريد الإلكتروني',
            controller: emailController,
          ),
          SizedBox(height: spacing),

          // Password Field
          CustomTextField(
            labelText: 'أدخل كلمة المرور',
            controller: passwordController,
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
