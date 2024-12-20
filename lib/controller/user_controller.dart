import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_details.dart';

class UserController extends GetxController with GetSingleTickerProviderStateMixin {
  static const String API_URL = 'https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientDetails';
  late AnimationController animationController;
  late Animation<double> animation;
  var isExpanded = false.obs;
  var userInfoDetails = Rx<UserDetails?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    fetchPatientDetails();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void toggleCard() {
    isExpanded.toggle();
    if (isExpanded.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  String bloodType(int? type) {
    if (type == null)  return 'not_specified'.tr;

    switch (type) {
      case 1:
        return "A+";
      case 2:
        return "A-";
      case 3:
        return "B+";
      case 4:
        return "B-";
      case 5:
        return "AB+";
      case 6:
        return "AB-";
      case 7:
        return "o+";
      case 8:
        return "o-";
      default:
        return 'not_specified'.tr;
    }
  }

  String getEmergencyContactRelationship(int? relationship) {
    switch (relationship) {
      case 1:
        return 'emergencyContactPage.father'.tr;
      case 2:
        return 'emergencyContactPage.mother'.tr;
      case 3:
        return 'emergencyContactPage.brother'.tr;
      case 4:
        return 'emergencyContactPage.sister'.tr;
      case 5:
        return 'emergencyContactPage.son'.tr;
      case 6:
        return 'emergencyContactPage.daughter'.tr;
      case 7:
        return 'emergencyContactPage.husband'.tr;
      case 8:
        return 'emergencyContactPage.wife'.tr;
      case 9:
        return 'emergencyContactPage.other'.tr;
      default:
        return 'not_specified'.tr;
    }
  }


  final genderMap = {1: 'male'.tr, 2: 'female'.tr};
  String getGender(int? gender) => genderMap[gender] ?? 'not_specified'.tr;

  Future<void> fetchPatientDetails() async {

    isLoading.value = true;
    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jwtToken = prefs.getString('token');

      print('JWT Token: ${jwtToken?.substring(0, 10)}...');

      if (jwtToken == null) throw Exception('JWT token is missing');

      final response = await http.get(
        Uri.parse(API_URL),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        userInfoDetails.value = UserDetails.fromJson(jsonResponse);

        print('Parsed user details: ${userInfoDetails.value?.toJson()}');
      } else {
        print(response.body);
        throw Exception('Failed to load patient details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchPatientDetails: $e');
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء جلب بيانات المريض",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
