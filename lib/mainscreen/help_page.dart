import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../languages.dart';

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
            'name': item['centerName'] ?? 'center_not_specified'.tr,
            'number': item['phoneNumCenter']?.toString() ?? 'number_not_available'.tr,
            'lat': item['lot'],
            'lng': item['lag'],
          };
        }).toList();
      } else {
        errorMessage.value = 'support_numbers_load_error'.tr;
      }
    } catch (e) {
      errorMessage.value = 'unexpected_error'.tr;
    } finally {
      isLoading(false);
    }
  }Future<void> _showCallOptions(String phoneNumber) async {
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.25,
          minChildSize: 0.2,
          maxChildSize: 0.4,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اختر وسيلة الاتصال',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF259E9F),
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.phone, color: Color(0xFF259E9F)),
                      title: Text(
                        'اتصال هاتفي',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _makePhoneCall(phoneNumber);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_in_talk_outlined, color: Color(0xFF259E9F)),
                      title: Text(
                        'واتس اب',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _launchWhatsApp(phoneNumber);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'تعذر الاتصال بـ $phoneNumber';
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('WhatsApp غير مثبت')),
      );
    }
  }
}

class Quicksupportnumbers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuicksupportnumbersController());

    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
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
            'help'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                    padding: EdgeInsets.all(Get.width * 0.05),
                    child: Container(
                      padding: EdgeInsets.all(Get.width * 0.05),
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
                            'support_number_128'.tr,
                            style: TextStyle(
                              color: Color(0xFf259e9f),
                              fontSize: Get.width * 0.12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            'support_number_description'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: Get.width * 0.04,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            'service_available'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: Get.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Get.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'emergency_numbers'.tr,
                          style: TextStyle(
                            color: Color(0xFf259e9f),
                            fontSize: Get.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.supportNumbers.length,
                          itemBuilder: (context, index) {
                            final number = controller.supportNumbers[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: Get.height * 0.02),
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
            fontSize: Get.width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          number['number']!,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: Get.width * 0.035,
          ),
        ),
        trailing: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/phone.svg',
            color: Color(0xFf259e9f),
            width: Get.width * 0.06,
            height: Get.width * 0.06,
          ),
          onPressed: () => Get.find<QuicksupportnumbersController>()._showCallOptions(number['number']!),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}