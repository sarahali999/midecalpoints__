import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom.dart';

class MedicalInfoPage extends StatefulWidget {
  final int selectedBloodType;
  final TextEditingController chronicDiseasesController;
  final TextEditingController allergiesController;
  final ValueChanged<int?> onBloodTypeChanged;

  const MedicalInfoPage({
    required this.selectedBloodType,
    required this.chronicDiseasesController,
    required this.allergiesController,
    required this.onBloodTypeChanged,
    Key? key,
  }) : super(key: key);

  @override
  _MedicalInfoPageState createState() => _MedicalInfoPageState();
}

class _MedicalInfoPageState extends State<MedicalInfoPage> {
  final Map<String, int> bloodTypeOptions = {
    'A+': 1,
    'A-': 2,
    'B+': 3,
    'B-': 4,
    'AB+': 5,
    'AB-': 6,
    'O+': 7,
    'O-': 8,
  };

  late final Map<int, String> bloodTypeFromId;
  late String? selectedBloodTypeString;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    double spacing = screenHeight * 0.02;
    EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: spacing,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'فصيلة الدم',
                border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
                filled: true,
                fillColor: const Color(0xFFd6dedf),
              ),
              items: bloodTypeOptions.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBloodTypeString = newValue;
                    widget.onBloodTypeChanged(bloodTypeOptions[newValue]);
                  });
                }
              },
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'الحساسية',
              controller: widget.allergiesController,
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'الامراض المزمنة',
              controller: widget.chronicDiseasesController,
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}