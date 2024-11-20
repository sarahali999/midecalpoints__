import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class QuicksupportnumbersController extends GetxController {
  var supportNumbers = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final String apiUrl = 'https://medicalpoint-api.tatwer.tech/api/Mobile/GetAllCenters';

  @override
  void onInit() {
    super.onInit();
    fetchSupportNumbers();
  }

  Future<void> fetchSupportNumbers() async {
    isLoading(true);
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        supportNumbers.value = items.map((item) {
          return {
            'name': item['centerName'] ?? 'غير محدد',
            'number': item['phoneNumCenter']?.toString() ?? 'رقم غير متاح',
            'lat': item['lot'],
            'lng': item['lag'],
          };
        }).toList();
      } else {
        errorMessage.value = 'فشل تحميل أرقام الدعم';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'تعذر الاتصال بـ $phoneNumber';
    }
  }
}

class Quicksupportnumbers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuicksupportnumbersController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'مساعدة',
          style: TextStyle(
            color: Colors.white,
            fontSize: Get.width * 0.05, // Responsive font size
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFF5BB9AE),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Get.width * 0.05), // Responsive padding
                  child: Container(
                    padding: EdgeInsets.all(Get.width * 0.05), // Responsive padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '128',
                          style: TextStyle(
                            color: Color(0xFF5BB9AE),
                            fontSize: Get.width * 0.12, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02), // Responsive spacing
                        Text(
                          'يستقبل الرقم الاتصال على الرقم 128 من جميع الشبكات مجانا',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: Get.width * 0.04, // Responsive font size
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01), // Responsive spacing
                        Text(
                          'الخدمة متوفرة على مدار 24 ساعة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: Get.width * 0.04, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Get.width * 0.05), // Responsive padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ارقام الطوارئ',
                        style: TextStyle(
                          color: Color(0xFF5BB9AE),
                          fontSize: Get.width * 0.05, // Responsive font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02), // Responsive spacing
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.supportNumbers.length,
                        itemBuilder: (context, index) {
                          final number = controller.supportNumbers[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: Get.height * 0.02), // Responsive spacing
                            child: _buildSupportNumberCard(number),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSupportNumberCard(Map<String, dynamic> number) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          number['name']!,
          style: TextStyle(
            fontSize: Get.width * 0.04, // Responsive font size
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          number['number']!,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: Get.width * 0.035, // Responsive font size
          ),
        ),
        trailing: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/phone.svg',
            color: Colors.green,
            width: Get.width * 0.06, // Responsive icon size
            height: Get.width * 0.06, // Responsive icon size
          ),
          onPressed: () => Get.find<QuicksupportnumbersController>()._makePhoneCall(number['number']!),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
