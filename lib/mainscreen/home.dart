import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../languages.dart';
import '../loading_screen.dart';
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
      return 'loading_medications'.tr;
    }

    if (recentMedications.isEmpty) {
      return 'display_dispensed_medications'.tr;
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
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                height: Get.height *0.3,
                child: News(),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child:
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(
                              onLoaded: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiagnosisPage()),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: SmallCard(
                        title: 'diagnosis_and_notes'.tr,
                        iconPath: 'assets/icons/Medical.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child:GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(
                              onLoaded: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChronicDiseasesPage()),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: SmallCard(
                        title: 'chronic_diseases'.tr,
                        iconPath: 'assets/icons/health.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child:GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(
                              onLoaded: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => MedicalSuppliesWidget()),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: SmallCard(
                        title: 'medical_supplies'.tr,
                        iconPath: 'assets/icons/heart.png',
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
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        onLoaded: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MedicationListWidget()),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: LargeCard(
                  content: _buildMedicationContent(),
                  title: 'dispensed_medications'.tr,
                  iconPath: 'assets/icons/pill.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}