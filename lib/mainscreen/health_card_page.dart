import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controller/user_controller.dart';
import '../languages.dart';

class HealthInfo extends StatelessWidget {
  HealthInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color(0xFf259e9f),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppBar(),
                SizedBox(height: Get.height * 0.0),
                _buildUserInfo(controller),
                SizedBox(height: Get.height * 0.02),
              ],
            ),
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
          'health_card'.tr,
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

  Widget _buildUserCard(UserController controller) {
    final userData = controller.userInfoDetails.value?.data;
    final user = userData?.user;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.03, horizontal: Get.width * 0.05),
            decoration: BoxDecoration(
              color: Color(0xffc1dbdd).withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${user?.firstName ?? ''} ${user?.secondName ?? ''}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.width * 0.06,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff386161),
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(Get.width * 0.05),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.phone_rounded,
                  label: 'phone_number'.tr,
                  value: user?.phoneNumber ?? 'not_available'.tr,
                ),
                _buildDetailRow(
                  icon: Icons.person_rounded,
                  label: 'gender'.tr,
                  value: controller.getGender(userData?.gender),
                ),
                _buildDetailRow(
                  icon: Icons.water_drop_rounded,
                  label: 'blood_type'.tr,
                  value: controller.bloodType(userData?.bloodType),
                ),
                _buildDetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'birth_date'.tr,
                  value: userData?.birthYear ?? 'not_available'.tr,
                ),
              ],
            ),
          ),

          // QR Code Section
          Padding(
            padding: EdgeInsets.only(bottom: Get.width * 0.05),
            child: Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator(color: Colors.white);
              } else if (controller.userInfoDetails.value?.data?.randomCode == null) {
                return _buildNoQRCodeText();
              } else {
                return _buildQrCodeContainer(controller.userInfoDetails.value?.data?.randomCode);
              }
            }),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms);
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFf259e9f), size: Get.width * 0.06),
          SizedBox(width: Get.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Get.width * 0.035,
                  color: Color(0xff386161),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  color: Color(0xff386161),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataText() {
    return Center(
      child: Text(
        'no_data_available'.tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: Get.width * 0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNoQRCodeText() {
    return Center(
      child: Text(
        'qr_code_unavailable'.tr,
        style: TextStyle(
          color: Colors.white70,
          fontSize: Get.width * 0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildQrCodeContainer(String? qrData) {
    if (qrData == null || qrData.isEmpty) {
      return Text('error_occurred'.tr, style: TextStyle(color: Colors.white));
    }
    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto,
        size: Get.width * 0.5,
        backgroundColor: Colors.white,
      ).animate()
          .scale(duration: 500.ms)
          .fadeIn(duration: 700.ms),
    );
  }
}