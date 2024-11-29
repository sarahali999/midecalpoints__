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
}class _MedicalInfoPageState extends State<MedicalInfoPage> {
  final Map<String, int> bloodTypeOptions = {
    'غير معروف': 0,
    'A+': 1,
    'A-': 2,
    'B+': 3,
    'B-': 4,
    'AB+': 5,
    'AB-': 6,
    'O+': 7,
    'O-': 8,
  };

  String? _currentBloodType;

  @override
  void initState() {
    super.initState();
    // تعيين القيمة الأولية
    _currentBloodType = widget.selectedBloodType == 0 ? null : bloodTypeOptions.entries
        .firstWhere((entry) => entry.value == widget.selectedBloodType)
        .key;
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
        value: _currentBloodType,
        hint: Text('اختر فصيلة الدم'), // نص تلميحي عندما لا يوجد اختيار
    decoration: InputDecoration(
    labelText: 'blood_type'.tr,
    border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10.0),
    ),
    filled: true,
    fillColor: const Color(0xFFd6dedf),
    ),
    items: bloodTypeOptions.entries
        .where((entry) => entry.value != 0)
        .map((entry) {
    return DropdownMenuItem<String>(
    value: entry.key,
    child: Text(entry.key),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _currentBloodType = newValue;
    widget.onBloodTypeChanged(newValue != null ? bloodTypeOptions[newValue] : 0);
    });
    }
    ),

          SizedBox(height: spacing),
            CustomTextField(
              labelText: 'allergies'.tr,
              controller: widget.allergiesController,
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'chronic_diseases'.tr,
              controller: widget.chronicDiseasesController,
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}