import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;  // Add onSubmitted callback

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.focusNode,
    this.onSubmitted,  // Include onSubmitted in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      focusNode: focusNode, // Use the focusNode here
      onSubmitted: onSubmitted, // Pass the onSubmitted callback
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Color(0xFFd6dedf),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      style: TextStyle(color: Colors.black87),
    );
  }
}
