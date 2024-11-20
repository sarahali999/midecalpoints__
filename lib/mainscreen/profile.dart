import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';
import '../models/UserDetails.dart';

class UserProfile extends GetView<UserController> {
  @override
  final UserController controller = Get.put(UserController());

  UserProfile({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.userInfoDetails.value == null) {
            return Center(child: Text("لا تتوفر بيانات في الوقت الحالي"));
          } else {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildProfileHeader(controller.userInfoDetails.value!.data!),
                      _buildInfoSection(controller.userInfoDetails.value!.data!),
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

  Widget _buildProfileHeader(Data user) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Hero(
            tag: 'profile-image',
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/dd.jpg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(
            "${user.user?.firstName ?? ''} ${user.user?.secondName ?? ''} ${user.user?.thirdName ?? ''}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0),
          const SizedBox(height: 8),
          Text(
            user.user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 250.ms).slideY(begin: 0.5, end: 0),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Data userData) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "المعلومات الشخصية", // نص مباشر
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoTile(Icons.person, "الاسم الكامل", "${userData.user?.firstName ?? ''} ${userData.user?.secondName ?? ''} ${userData.user?.thirdName ?? ''}"),
          _buildInfoTile(Icons.email, "البريد الإلكتروني", userData.user?.email ?? ''),
          _buildInfoTile(Icons.person_outline, "اسم المستخدم", userData.user?.username ?? ''),
          _buildInfoTile(Icons.phone, "رقم الهاتف", userData.user?.phoneNumber ?? ''),
          _buildInfoTile(Icons.cake, "سنة الميلاد", userData.birthYear ?? ''),
          _buildInfoTile(Icons.wc, "الجنس", controller.getGender(userData.gender,)),
          _buildInfoTile(Icons.local_hospital, "فصيلة الدم", controller.bloodType(userData.bloodType)),
          _buildInfoTile(Icons.flag, "الدولة", userData.country ?? ''),
          _buildInfoTile(Icons.location_on, "المحافظة", userData.province ?? ''),
          _buildInfoTile(Icons.location_city, "الحي", userData.district ?? ''),
          _buildInfoTile(Icons.location_city, "الزقاق", userData.alley ?? ''),
          _buildInfoTile(Icons.location_city, "المنزل", userData.house ?? ''),
          _buildInfoTile(Icons.medical_services, "الأمراض المزمنة", userData.chronicDiseases ?? "لا يوجد"),
          _buildInfoTile(Icons.warning, "الحساسيات", userData.allergies ?? "لا يوجد"),
          _buildInfoTile(Icons.contacts, "اسم جهة الاتصال في حالات الطوارئ", userData.emergencyContactFullName ?? ''),
          _buildInfoTile(Icons.phone_in_talk, "رقم الاتصال في حالات الطوارئ", userData.emergencyContactPhoneNumber ?? ''),
          _buildInfoTile(Icons.family_restroom, "علاقة جهة الاتصال في حالات الطوارئ", controller.getEmergencyContactRelationship(userData.emergencyContactRelationship)),
          _buildInfoTile(Icons.flag, "دولة جهة الاتصال في حالات الطوارئ", userData.emergencyContactCountry ?? ''),
          _buildInfoTile(Icons.location_on, "محافظة جهة الاتصال في حالات الطوارئ", userData.emergencyContactProvince ?? ''),
          _buildInfoTile(Icons.location_city, "حي جهة الاتصال في حالات الطوارئ", userData.emergencyContactDistrict ?? ''),
          _buildInfoTile(Icons.location_city, "زقاق جهة الاتصال في حالات الطوارئ", userData.emergencyContactAlley ?? ''),
          _buildInfoTile(Icons.location_city, "منزل جهة الاتصال في حالات الطوارئ", userData.emergencyContactHouse ?? ''),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms).slideY(begin: 0.1, end: 0);
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return '';
    final dateTime = DateTime.parse(dateTimeString);
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5BB9AE), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
