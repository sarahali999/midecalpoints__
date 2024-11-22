import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chronicDiseasesPage.dart';
import 'diagnosisPage.dart';
import 'examinationPage.dart';
import 'medicationsPage.dart';
import 'news.dart';
import 'card_widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isRTL = true;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        title: 'diagnosisPage.title'.tr,
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
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MedicationListWidget()),
                        );
                      },
                      child: SmallCard(
                        title: 'medicationsPage.title'.tr,
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
                    MaterialPageRoute(builder: (context) => MedicationsPage()),
                  );
                },
                child: LargeCard(
                  content: 'AMPICILLIN\nAMPHOTERICIN\nAMPICILLIN',
                  title: 'medicationsPage.prescribedMedications'.tr,
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