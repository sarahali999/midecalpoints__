import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationListWidget extends StatefulWidget {
  @override
  _MedicationListWidgetState createState() => _MedicationListWidgetState();
}

class _MedicationListWidgetState extends State<MedicationListWidget> {
  List<dynamic> medications = [];
  bool isLoading = true;
  String? errorMessage;
  String? jwtToken;

  @override
  void initState() {
    super.initState();
    fetchJwtTokenAndMedications();
  }

  Future<void> fetchJwtTokenAndMedications() async {
    await fetchJwtToken();
    if (jwtToken != null) {
      fetchMedications();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "jwt_token_fetch_failed".tr;
      });
    }
  }

  Future<void> fetchJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('token');
    });
  }

  Future<void> fetchMedications() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientDispenseMedications?PageNumber=1&PageSize=11',
        ),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          medications = data['value']['items'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'medication_load_failed'.tr;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
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
          'medication_list'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: isLoading
            ? Center(
        )
            : errorMessage != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                errorMessage!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: medications.length,
          itemBuilder: (context, index) {
            final medication = medications[index];
            final details = medication['medication'];
            final patient = medication['patient'];
            final medicalStaff = medication['medicalStaff'];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
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
                            Icons.medication,
                            color: Color(0xFF259E9F),
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              details['name'] ?? "N/A",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF259E9F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('medication_info'.tr),
                          _buildInfoRow(
                            'generic_name'.tr,
                            details['genericName'],
                            Icons.label_outline,
                          ),
                          _buildInfoRow(
                            'dosage_form'.tr,
                            details['dosageForm'],
                            Icons.medical_services_outlined,
                          ),
                          _buildInfoRow(
                            'production_date'.tr,
                            details['productionDate'] != null
                                ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(
                                    details['productionDate']))
                                : "N/A",
                            Icons.calendar_today,
                          ),
                          _buildInfoRow(
                            'expiry_date'.tr,
                            details['expiryDate'] != null
                                ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(
                                    details['expiryDate']))
                                : "N/A",
                            Icons.event_busy,
                          ),
                          Divider(height: 32),
                          _buildSectionTitle('doctor_info'.tr),
                          _buildInfoRow(
                            'specialization'.tr,
                            medicalStaff['specialization'],
                            Icons.work_outline,
                          ),
                          _buildInfoRow(
                            'medical_center'.tr,
                            medicalStaff['center']['centerName'],
                            Icons.business,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF259E9F),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value ?? 'not_available'.tr,
                  style: TextStyle(
                    fontSize: 16,
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