import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controller/user_controller.dart';

class HealthInfo extends StatelessWidget {
  HealthInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    return Scaffold(
      backgroundColor: Color(0xFf259e9f),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),
              SizedBox(height: Get.height * 0.02),
              _buildUserInfo(controller),
              SizedBox(height: Get.height * 0.02),
              _buildQRCodeSection(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
      child: AppBar(
        backgroundColor: Color(0xFf259e9f),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'health_card'.tr, // Updated to use translation
          style: TextStyle(
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: Colors.white));
      } else if (controller.userInfoDetails.value == null) {
        return _buildNoDataText();
      } else {
        return _buildUserCard(controller);
      }
    });
  }

  Widget _buildNoDataText() {
    return Center(
      child: Text(
        'no_data_available'.tr, // Updated to use translation
        style: TextStyle(color: Colors.white, fontSize: Get.width * 0.04),
      ),
    );
  }

  Widget _buildUserCard(UserController controller) {
    final userData = controller.userInfoDetails.value?.data;
    final user = userData?.user;

    return Container(
      padding: EdgeInsets.all(Get.width * 0.04),
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "${user?.firstName ?? ''} ${user?.secondName ?? ''}",
            style: TextStyle(fontSize: Get.width * 0.06, fontWeight: FontWeight.bold, color: Color(0xFf259e9f)),
          ),
          SizedBox(height: Get.height * 0.01),
          _buildInfoRow(Icons.phone, "${'phone_number'.tr}: ${user?.phoneNumber ?? 'not_available'.tr}"),
          _buildInfoRow(
            Icons.person,
            "${'gender'.tr}: ${controller.getGender(userData?.gender)}",
          ),
          _buildInfoRow(
            Icons.water_drop,
            "${'blood_type'.tr}: ${controller.bloodType(userData?.bloodType)}",
          ),
          _buildInfoRow(
            Icons.calendar_today,
            "${'age'.tr}: ${userData?.birthYear ?? 'not_available'.tr}",
          ),
          SizedBox(height: Get.height * 0.02),
          Text(
            'health_directorate'.tr, // Updated to use translation
            style: TextStyle(fontSize: Get.width * 0.04, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFf259e9f), size: Get.width * 0.06),
          SizedBox(width: Get.width * 0.03),
          Text(
            text,
            style: TextStyle(fontSize: Get.width * 0.04, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection(UserController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return CircularProgressIndicator(color: Colors.white);
      } else if (controller.userInfoDetails.value?.data?.randomCode == null) {
        return _buildNoQRCodeText();
      } else {
        return _buildQrCodeContainer(controller.userInfoDetails.value?.data?.randomCode);
      }
    });
  }

  Widget _buildNoQRCodeText() {
    return Center(
      child: Text(
        'qr_code_unavailable'.tr, // Updated to use translation
        style: TextStyle(color: Colors.white, fontSize: Get.width * 0.04),
      ),
    );
  }

  Widget _buildQrCodeContainer(String? qrData) {
    if (qrData == null || qrData.isEmpty) {
      return Text('error_occurred'.tr, style: TextStyle(color: Colors.white)); // Updated to use translation
    }
    return Container(
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto,
        size: Get.width * 0.6,
      ).animate().scale(duration: 500.ms).fadeIn(duration: 700.ms),
    );
  }
}