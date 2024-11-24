import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chronicDiseasesPage.dart';
import 'diagnosisPage.dart';
import 'examinationPage.dart';
import 'news.dart';
import 'card_widgets.dart';

class HomePage extends StatelessWidget {
  bool isRTL = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 16),
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
                        title: 'diagnosis_notes'.tr,
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
                        title: 'chronic_diseases'.tr,
                        iconPath: 'assets/icons/health.svg',
                        iconColor: Color(0xFF2196F3),
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
                  content: 'medications_list'.tr,
                  title: 'my_medications'.tr,
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