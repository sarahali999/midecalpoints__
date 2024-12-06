import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiagnosisPage extends StatefulWidget {
  @override
  _DiagnosisPageState createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  List<dynamic> receipts = [];
  bool isLoading = true;
  String? errorMessage;
  String? jwtToken;

  @override
  void initState() {
    super.initState();
    fetchJwtToken();
  }

  Future<void> fetchJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken = prefs.getString('token');
    if (jwtToken != null) {
      fetchPatientReceipts();
    } else {
      setState(() {
        errorMessage = 'no_jwt_token'.tr;
        isLoading = false;
      });
    }
  }

  Future<void> fetchPatientReceipts() async {
    try {
      final response = await http.get(
        Uri.parse('https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientReceipts'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          receipts = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'data_load_error'.tr;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'connection_error'.tr + ': $e';
        isLoading = false;
      });
    }
  }

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
          'complete_medical_status'.tr,
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/warning.svg',
              height: 180,
              width: 200,
            ),
            SizedBox(height: 16),

          ],
        ),
      )
          : receipts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/nodata.svg', // أيقونة لا توجد بيانات
              height: 180,
              width: 200,            ),
            SizedBox(height: 16),
            Text(
              'no_diagnosis'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF259E9F),
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: receipts.length,
          itemBuilder: (context, index) {
            final receipt = receipts[index];
            return buildDiagnosisCard(receipt);
          },
        ),
      ),
    );
  }

  Widget buildDiagnosisCard(Map<String, dynamic> receipt) {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader('medical_status'.tr, Icons.medical_services),
              SizedBox(height: 10),
              buildInfoRow('diagnosis_label'.tr, receipt['notes'] ?? 'not_available'.tr),
              buildInfoRow(
                'treating_doctor_label'.tr,
                '${receipt['medicalStaff']?['user']?['firstName'] ?? ''} ${receipt['medicalStaff']?['user']?['secondName'] ?? ''}',
              ),
              buildInfoRow('specialization_label'.tr, receipt['medicalStaff']?['specialization'] ?? 'not_available'.tr),
              buildInfoRow('medical_center_label'.tr, receipt['medicalStaff']?['center']?['centerName'] ?? 'not_available'.tr),
              buildInfoRow('address_label'.tr, receipt['medicalStaff']?['center']?['addressCenter'] ?? 'not_available'.tr),
              buildInfoRow('phone_label'.tr, receipt['medicalStaff']?['center']?['phoneNumCenter'] ?? 'not_available'.tr),
              buildInfoRow('diagnosis_date_label'.tr, formatDate(receipt['createdAt'] ?? '')),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF259E9F), size: 28),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF259E9F)),
        ),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'not_available'.tr,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return 'not_available'.tr;
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return 'not_available'.tr;
    }
  }
}