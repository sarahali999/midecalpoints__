import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';

class ChronicDiseasesPage extends GetView<UserController> {
  final UserController controller = Get.put(UserController());

  ChronicDiseasesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF3EB49B),
        title: Text(
          'الامراض المزمنة والحساسية',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchPatientDetails,  // Fixed to use controller
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Refresh Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Color(0xFF3EB49B)),
                  onPressed: controller.fetchPatientDetails,  // Fixed to use controller
                ),
              ),
              SizedBox(height: 8),

              // Chronic Diseases Card
              _buildInfoCard(
                title: 'مرض مزمن',
                content: controller.userInfoDetails.value?.data?.chronicDiseases?.isNotEmpty == true
                    ? controller.userInfoDetails.value!.data!.chronicDiseases!
                    : 'لا يعاني من مرض مزمن',
              ),

              SizedBox(height: 16),

              // Allergies Card
              _buildInfoCard(
                title: 'الحساسية',
                content: controller.userInfoDetails.value?.data?.allergies?.isNotEmpty == true
                    ? controller.userInfoDetails.value!.data!.allergies!
                    : 'لا يعاني من حساسية',
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE8F5F3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield, color: Color(0xFF3EB49B)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

        ],
      ),
    );
  }
}
