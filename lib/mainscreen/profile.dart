import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';
import '../models/UserDetails.dart';

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
            return const Center(child: CircularProgressIndicator());
          } else if (controller.userInfoDetails.value == null) {
            return const Center(child: Text("لا تتوفر بيانات في الوقت الحالي"));
          } else {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildProfileHeader(controller.userInfoDetails.value!.data!, screenWidth, screenHeight),
                      _buildPersonalInfo(controller.userInfoDetails.value!.data!, screenWidth),
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
        color: Color(0xFF5BB9AE),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      child: Column(
        children: [
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
              _buildQuickInfo(controller.bloodType(user.bloodType), "فصيلة الدم", screenWidth),
              _buildQuickInfo("${user.birthYear ?? ''}", "العمر", screenWidth),
              _buildQuickInfo(controller.getGender(user.gender), "الجنس", screenWidth),
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
          const Text(
            "معلومات المستخدم",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile("الاسم الكامل", "${user.user?.firstName ?? ''} ${user.user?.secondName ?? ''} ${user.user?.thirdName ?? ''}", screenWidth),
          _buildInfoTile("اسم المستخدم", user.user?.username ?? '', screenWidth),
          _buildInfoTile("البريد الإلكتروني", user.user?.email ?? '', screenWidth),
          _buildInfoTile("رقم الهاتف", user.user?.phoneNumber ?? '', screenWidth),
           const SizedBox(height: 16),
          const Text(
            "عنوان المستخدم",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile("البلد", user.country ?? '', screenWidth),
          _buildInfoTile("المحافظة", user.province ?? '', screenWidth),
          _buildInfoTile("المحلة", user.district ?? '', screenWidth),
          _buildInfoTile("الزقاق", user.alley ?? '', screenWidth),
          _buildInfoTile("الدار", user.house ?? '', screenWidth),
          const SizedBox(height: 16),
          const Text(
            "معلومات الشخص المقرب",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile("اسم الشخص المقرب", user.emergencyContactFullName ?? '', screenWidth),
          _buildInfoTile("رقم هاتف الشخص المقرب", user.emergencyContactPhoneNumber ?? '', screenWidth),
          _buildInfoTile("صلة القرابة", controller.getEmergencyContactRelationship(user.emergencyContactRelationship), screenWidth),
          const SizedBox(height: 16),
          const Text(
            "عنوان الشخص المقرب",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildInfoTile("بلد الشخص المقرب", user.emergencyContactCountry ?? '', screenWidth),
          _buildInfoTile("محافظة الشخص المقرب", user.emergencyContactProvince ?? '', screenWidth),
          _buildInfoTile("محلة الشخص المقرب", user.emergencyContactDistrict ?? '', screenWidth),
          _buildInfoTile("زقاق الشخص المقرب", user.emergencyContactAlley ?? '', screenWidth),
          _buildInfoTile("دار الشخص المقرب", user.emergencyContactHouse ?? '', screenWidth),
          const SizedBox(height: 16),
          _buildInfoTile("الرمز العشوائي", user.randomCode ?? '', screenWidth),
        ],
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
