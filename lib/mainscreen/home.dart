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
  final TextEditingController _feedbackController = TextEditingController();
  List<dynamic> recentMedications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecentMedications();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _showFeedbackDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.feedback_outlined,
                      color: Color(0xFF259E9F),
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'رأيك يهمنا'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF259E9F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[50],
                    border: Border.all(
                      color: Color(0xFF259E9F).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب ملاحظاتك'.tr,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _feedbackController.clear();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          color: Color(0xFF259E9F),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: () async {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF259E9F),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'ارسال'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  //
  // Future<void> _submitFeedback() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final jwtToken = prefs.getString('token');
  //
  //     if (jwtToken != null) {
  //       final response = await http.post(
  //         Uri.parse('https://medicalpoint-api.tatwer.tech/api/Mobile/SubmitFeedback'),
  //         headers: {
  //           'Authorization': 'Bearer $jwtToken',
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({
  //           'feedback': _feedbackController.text,
  //         }),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('feedback_submitted'.tr),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //       } else {
  //         throw Exception('Failed to submit feedback');
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('error_submitting_feedback'.tr),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

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
    return Scaffold(
      body: Directionality(
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
                  height: Get.height * 0.3,
                  child: News(),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
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
                      child: GestureDetector(
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
                      child: GestureDetector(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFeedbackDialog,
        backgroundColor: Color(0xFF259E9F),
        child: Icon(Icons.feedback, color: Colors.white),
        tooltip: 'feedback'.tr,
      ),
    );
  }
}