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
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          CustomTextField(
            labelText: 'username'.tr,
            controller: usernameController,
          ),
          SizedBox(height: spacing),
          Form(
            key: _formKey,
            child: IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'phone_number'.tr,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: const Color(0xFFd6dedf),
              ),
              initialCountryCode: 'IQ',
              textAlign: TextAlign.right,
              invalidNumberMessage: 'invalid_phone'.tr,
              onChanged: (phone) {
                phoneController.text = phone.completeNumber;
                print(phone.completeNumber);
              },
              onCountryChanged: (country) {
                _formKey.currentState?.reset();
                print('Country changed to: ${country.code}');
              },
            ),
          ),
          SizedBox(height: spacing),
          CustomTextField(
            labelText: 'email'.tr,
            controller: emailController,
          ),
          SizedBox(height: spacing),
          CustomTextField(
            labelText: 'enter_password'.tr,
            controller: passwordController,
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
