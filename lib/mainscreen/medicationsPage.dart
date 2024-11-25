import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        errorMessage = "فشل في جلب رمز JWT.";
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
          errorMessage = 'فشل في تحميل الأدوية';
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
        title: Text(
          'قائمة الأدوية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF259E9F),
                Color(0xFF1A7F80),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF259E9F)),
          ),
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
                          _buildSectionTitle('معلومات الدواء'),
                          _buildInfoRow(
                            'الاسم العام',
                            details['genericName'],
                            Icons.label_outline,
                          ),
                          _buildInfoRow(
                            'الشكل الجرعي',
                            details['dosageForm'],
                            Icons.medical_services_outlined,
                          ),
                          _buildInfoRow(
                            'تاريخ الإنتاج',
                            details['productionDate'] != null
                                ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(
                                    details['productionDate']))
                                : "N/A",
                            Icons.calendar_today,
                          ),
                          _buildInfoRow(
                            'تاريخ انتهاء الصلاحية',
                            details['expiryDate'] != null
                                ? DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(
                                    details['expiryDate']))
                                : "N/A",
                            Icons.event_busy,
                          ),
                          Divider(height: 32),
                          _buildSectionTitle('معلومات المريض'),
                          _buildInfoRow(
                            'اسم المريض',
                            '${patient['user']['firstName']} ${patient['user']['secondName']}',
                            Icons.person_outline,
                          ),
                          _buildInfoRow(
                            'الجنس',
                            patient['gender'] == 1
                                ? 'ذكر'
                                : patient['gender'] == 2
                                ? 'أنثى'
                                : 'غير محدد',
                            Icons.wc,
                          ),
                          _buildInfoRow(
                            'الأمراض المزمنة',
                            patient['chronicDiseases'] ?? "N/A",
                            Icons.local_hospital_outlined,
                          ),
                          Divider(height: 32),
                          _buildSectionTitle('معلومات الطبيب'),
                          _buildInfoRow(
                            'التخصص',
                            medicalStaff['specialization'],
                            Icons.work_outline,
                          ),
                          _buildInfoRow(
                            'المركز الطبي',
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
                  value ?? 'N/A',
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