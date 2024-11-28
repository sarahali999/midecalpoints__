import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chronic_diseases_page.dart';
import 'diagnosis_page.dart';
import 'examination_page.dart';
import 'medications_page.dart';
import 'news.dart';
import 'card_widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> recentMedications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecentMedications();
  }

  Future<void> fetchRecentMedications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('token');

      if (jwtToken != null) {
        final response = await http.get(
          Uri.parse(
            'https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientDispenseMedications?PageNumber=1&PageSize=2',
          ),
          headers: {
            'Authorization': 'Bearer $jwtToken',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            recentMedications = data['value']['items'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String _buildMedicationContent() {
    if (isLoading) {
      return 'جاري تحميل الأدوية...';
    }

    if (recentMedications.isEmpty) {
      return 'عرض الادوية المصروفة\nوتفاصيل الصرف';
    }

    String content = '';
    for (var i = 0; i < recentMedications.length; i++) {
      final medication = recentMedications[i]['medication'];
      content += '${i + 1}. ${medication['name']}\n';
    }
    return content.trimRight();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                height: Get.height * 0.25,
                child: News(),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DiagnosisPage()),
                        );
                      },
                      child: SmallCard(
                        title: 'التشخيص\nوالملاحظات',
                        iconPath: 'assets/icons/heart.svg',
                        iconColor: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChronicDiseasesPage()),
                        );
                      },
                      child: SmallCard(
                        title: 'الأمراض\nالمزمنة',
                        iconPath: 'assets/icons/health.svg',
                        iconColor: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MedicalSuppliesWidget()),
                        );
                      },
                      child: SmallCard(
                        title: 'المستلزمات\nالطبية',
                        iconPath: 'assets/icons/medical.svg',
                        iconColor: Color(0xFFFF5722),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MedicationListWidget()),
                  );
                },
                child: LargeCard(
                  content: _buildMedicationContent(),
                  title: 'الادوية المصروفة',
                  iconPath: 'assets/icons/pill.svg',
                  iconColor: Color(0xFFFF9800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
