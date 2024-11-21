import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class MedicationController extends GetxController {
  var medications = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var jwtToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJwtTokenAndMedications();
  }

  Future<void> fetchJwtTokenAndMedications() async {
    await fetchJwtToken();
    if (jwtToken.value.isNotEmpty) {
      await fetchMedications();
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken.value = prefs.getString('token') ?? '';
  }

  Future<void> fetchMedications() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientDispenseLaboratoryMaterial?PageNumber=1&PageSize=11',
        ),
        headers: {
          'Authorization': 'Bearer ${jwtToken.value}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        medications.value = data['value']['items'];
        isLoading.value = false;
      } else {
        throw Exception('Failed to load medications');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}

class MedicationListWidget extends StatelessWidget {
  final MedicationController _controller = Get.put(MedicationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'مواد مختبر المريض',
          style: TextStyle(
            color: Color(0xFf259e9f),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_controller.errorMessage.value.isNotEmpty) {
          return _buildErrorView(_controller.errorMessage.value);
        } else if (_controller.medications.isEmpty) {
          return _buildEmptyMedicationsView();
        } else {
          return _buildMedicationList();
        }
      }),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  Widget _buildEmptyMedicationsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            'لم يتم صرف الدواء بعد',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFf259e9f),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: _controller.medications.length,
      itemBuilder: (context, index) {
        final medication = _controller.medications[index];
        final labMaterial = medication['laboratoryMaterial'];
        final center = labMaterial['center'];
        return _buildMedicationCard(labMaterial, center);
      },
    );
  }

  Widget _buildMedicationCard(dynamic labMaterial, dynamic center) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFf259e9f),
              Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'محلول: ${labMaterial['solutionName'] ?? "N/A"}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow(
              Icons.science,
              'الاختبارات لكل عدة: ${labMaterial['testsPerKit'] ?? "N/A"}',
            ),
            _buildInfoRow(
              Icons.category,
              'عدد العدة: ${labMaterial['kitCount'] ?? "N/A"}',
            ),
            _buildInfoRow(
              Icons.business,
              'المورد: ${labMaterial['supplier'] ?? "N/A"}',
            ),
            _buildInfoRow(
              Icons.factory,
              'المنتج: ${labMaterial['producer'] ?? "N/A"}',
            ),
            Divider(),
            Text(
              'معلومات المركز',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFf259e9f),
              ),
            ),
            _buildInfoRow(
              Icons.local_hospital,
              'المركز: ${center['centerName'] ?? "N/A"}',
            ),
            _buildInfoRow(
              Icons.location_on,
              'الموقع: ${center['addressCenter'] ?? "N/A"}',
            ),
            Divider(),
            _buildInfoRow(
              Icons.calendar_today,
              'تاريخ الإنتاج: ${labMaterial['productionDate'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(labMaterial['productionDate'])) : "N/A"}',
            ),
            _buildInfoRow(
              Icons.hourglass_empty,
              'تاريخ انتهاء الصلاحية: ${labMaterial['expiryDate'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(labMaterial['expiryDate'])) : "N/A"}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
