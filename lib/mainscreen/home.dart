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
    return Directionality(
      textDirection: TextDirection.rtl,
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
                          MaterialPageRoute(builder: (context) => MedicationListWidget()),
                        );
                      },
                      child: SmallCard(
                        title: 'الفحوصات\nوالدواء',
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
                  title: 'الأدوية المصروفة لي',
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
