import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class MedicalSuppliesController extends GetxController {
  var supplies = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var jwtToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJwtTokenAndSupplies();
  }

  Future<void> fetchJwtTokenAndSupplies() async {
    await fetchJwtToken();
    if (jwtToken.value.isNotEmpty) {
      await fetchSupplies();
    } else {
      isLoading.value = false;
      errorMessage.value = "token_fetch_failed".tr;
    }
  }

  Future<void> fetchJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken.value = prefs.getString('token') ?? '';
  }
  Future<void> fetchSupplies() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientMedicalSuppliesDispense',
        ),
        headers: {
          'Authorization': 'Bearer ${jwtToken.value}',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        supplies.value = data['value']['items'] ?? [];
        isLoading.value = false;
      } else {
        throw Exception('Failed to load medical supplies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching supplies: $e');
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}

class MedicalSuppliesWidget extends StatelessWidget {
  final MedicalSuppliesController controller = Get.put(MedicalSuppliesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'medical_supplies'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorView(controller.errorMessage.value);
        }

        if (controller.supplies.isEmpty) {
          return _buildEmptyView();
        }

        return _buildSuppliesList();
      }),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 60,
            color: Color(0xFF259E9F),
          ),
          SizedBox(height: 16),
          Text(
            'no_medical_supplies'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF259E9F),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuppliesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.supplies.length,
      itemBuilder: (context, index) {
        final supply = controller.supplies[index];
        final medicalSupply = supply['medicalSupply'];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF5F5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF259E9F).withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: Color(0xFF259E9F),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          medicalSupply['name'] ?? 'not_specified'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF259E9F),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF259E9F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${'quantity'.tr}: ${supply['quantity']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.inventory, 'pieces_per_packet'.tr, '${medicalSupply['piecesPerPacket']}'),
                      _buildInfoRow(Icons.inventory_2, 'packet_count'.tr, '${medicalSupply['packetCount']}'),
                      _buildInfoRow(Icons.business, 'supplier'.tr, medicalSupply['supplier'] ?? 'not_specified'.tr),
                      _buildInfoRow(Icons.factory, 'producer'.tr, medicalSupply['producer'] ?? 'not_specified'.tr),
                      if (medicalSupply['expiryDate'] != null)
                        _buildInfoRow(
                          Icons.event,
                          'expiry_date'.tr,
                          DateFormat('yyyy-MM-dd').format(DateTime.parse(medicalSupply['expiryDate'])),
                        ),
                      Divider(height: 24),
                      Text(
                        'center_information'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF259E9F),
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.local_hospital, 'center_name'.tr, medicalSupply['center']['centerName'] ?? 'not_specified'.tr),
                      _buildInfoRow(Icons.location_on, 'address'.tr, medicalSupply['center']['addressCenter'] ?? 'not_specified'.tr),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}