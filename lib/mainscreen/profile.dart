import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';
import '../models/user_details.dart';
import 'edit_information.dart';

class UserProfile extends GetView<UserController> {
  @override
  final UserController controller = Get.put(UserController());

  UserProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(
              color: Color(0xFf259e9f),
            ));
          } else if (controller.userInfoDetails.value == null) {
            return Center(child: Text('no_data_available'.tr));
          } else {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildProfileHeader(controller.userInfoDetails.value!.data!, screenWidth, screenHeight),
                      _buildPersonalInfo(controller.userInfoDetails.value!.data!, screenWidth),
                      _buildEditProfileButton(screenWidth),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
  Widget _buildProfileHeader(Data user, double screenWidth, double screenHeight) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF259E9F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          const SizedBox(height: 50),
          Text(
            "${user.user?.firstName ?? ''} ${user.user?.secondName ?? ''} ${user.user?.thirdName ?? ''}",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickInfo(controller.bloodType(user.bloodType), 'blood_type'.tr, screenWidth),
              _buildQuickInfo("${user.birthYear ?? ''}", 'age'.tr, screenWidth),
              _buildQuickInfo(controller.getGender(user.gender), 'gender'.tr, screenWidth),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildQuickInfo(String value, String label, double screenWidth) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(Data user, double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'user_information'.tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile('full_name'.tr, "${user.user?.firstName ?? ''} ${user.user?.secondName ?? ''} ${user.user?.thirdName ?? ''}", screenWidth),
          _buildInfoTile('username'.tr, user.user?.username ?? '', screenWidth),
          _buildInfoTile('email'.tr, user.user?.email ?? '', screenWidth),
          _buildInfoTile('phone_number'.tr, user.user?.phoneNumber ?? '', screenWidth),
          const SizedBox(height: 16),
          Text(
            'user_address'.tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile('country'.tr, user.country ?? '', screenWidth),
          _buildInfoTile('province'.tr, user.province ?? '', screenWidth),
          _buildInfoTile('district'.tr, user.district ?? '', screenWidth),
          _buildInfoTile('alley'.tr, user.alley ?? '', screenWidth),
          _buildInfoTile('house'.tr, user.house ?? '', screenWidth),
          const SizedBox(height: 16),
          Text(
            'emergency_contact_information'.tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile('emergencyContactPage.fullName'.tr, user.emergencyContactFullName ?? '', screenWidth),
          _buildInfoTile('emergencyContactPage.phoneNumber'.tr, user.emergencyContactPhoneNumber ?? '', screenWidth),
          _buildInfoTile('emergencyContactPage.relationship'.tr, controller.getEmergencyContactRelationship(user.emergencyContactRelationship), screenWidth),
          const SizedBox(height: 16),
          Text(
            'emergency_contact_address'.tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile('emergencyContactPage.country'.tr, user.emergencyContactCountry ?? '', screenWidth),
          _buildInfoTile('emergencyContactPage.province'.tr, user.emergencyContactProvince ?? '', screenWidth),
          _buildInfoTile('emergencyContactPage.district'.tr, user.emergencyContactDistrict ?? '', screenWidth),
          _buildInfoTile('emergencyContactPage.alley'.tr, user.emergencyContactAlley ?? '', screenWidth),
          _buildInfoTile('emergencyContactPage.house'.tr, user.emergencyContactHouse ?? '', screenWidth),
          const SizedBox(height: 16),
          _buildInfoTile('random_code'.tr, user.randomCode ?? '', screenWidth),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.04,
        horizontal: screenWidth * 0.04,
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => EditProfilePage(userData: controller.userInfoDetails.value!.data!));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFf259e9f),
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.04,
            horizontal: screenWidth * 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'edit_personal_information'.tr,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}