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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFF259E9F),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        title: Text(
          'الامراض المزمنة والحساسية',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchPatientDetails,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Color(0xFf259e9f)),
                  onPressed: controller.fetchPatientDetails,
                ),
              ),
              SizedBox(height: 8),

              _buildInfoCard(
                title: 'مرض مزمن',
                content: controller.userInfoDetails.value?.data?.chronicDiseases?.isNotEmpty == true
                    ? controller.userInfoDetails.value!.data!.chronicDiseases!
                    : 'لا يعاني من مرض مزمن',
              ),

              SizedBox(height: 16),

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
              Icon(Icons.shield, color: Colors.orangeAccent),
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
