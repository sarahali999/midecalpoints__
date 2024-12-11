import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/introduction_screen.dart';

class DeleteAccount extends StatelessWidget {
  Future<void> _deleteAccount(BuildContext context) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title:  Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.red, size: 32),
                SizedBox(width: 15),
                Text(
                  'warning'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'confirm_account_deletion'.tr,
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.of(context).pop(false),
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
                  'confirm'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
    );

    if (confirmDelete == true) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? jwtToken = prefs.getString('token');

        if (jwtToken == null) {
          throw Exception('User info error');
        }

        final parts = jwtToken.split('.');
        if (parts.length != 3) {
          throw Exception('Invalid token format');
        }

        final payload = base64Url.normalize(parts[1]);
        final payloadMap = json.decode(utf8.decode(base64Url.decode(payload)));
        final String? userId = payloadMap['nameid'];

        if (userId == null) {
          throw Exception('User ID not found');
        }

        final url = Uri.parse('https://medicalpoint-api.tatwer.tech/api/Users/$userId');
        final response = await http.delete(
          url,
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'accept': 'text/plain',
          },
        );

        if (response.statusCode == 200) {
          await prefs.clear();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => OnboardingScreen(),
            ),
                (Route<dynamic> route) => false,
          );
        } else {
          throw Exception(response.body);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
              SizedBox(height: 10),
              Text(
                'confirm_account_deletion'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('cancel'.tr, style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _deleteAccount(context),
                    child: Text('confirm'.tr, style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
