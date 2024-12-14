import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom.dart';

class MedicalInfoPage extends StatefulWidget {
  final int selectedBloodType;
  final TextEditingController chronicDiseasesController;
  final TextEditingController allergiesController;
  final ValueChanged<int?> onBloodTypeChanged;

  final FocusNode chronicDiseasesFocusNode = FocusNode();
  final FocusNode allergiesFocusNode = FocusNode();

  MedicalInfoPage({
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
    _currentBloodType = widget.selectedBloodType == 0
        ? null
        : bloodTypeOptions.entries
        .firstWhere((entry) => entry.value == widget.selectedBloodType)
        .key;
  }

  void _showBloodTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: bloodTypeOptions.entries.length - 1,
                itemBuilder: (context, index) {
                  final entry = bloodTypeOptions.entries.where((e) => e.value != 0).toList()[index];
                  return ListTile(
                    title: Text(entry.key),
                    onTap: () {
                      setState(() {
                        _currentBloodType = entry.key;
                        widget.onBloodTypeChanged(entry.value);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
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
            GestureDetector(
              onTap: _showBloodTypePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFd6dedf),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentBloodType ?? 'اختر فصيلة الدم',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'allergies'.tr,
              controller: widget.allergiesController,
              focusNode: widget.allergiesFocusNode,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(widget.chronicDiseasesFocusNode);
              },
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'chronic_diseases'.tr,
              controller: widget.chronicDiseasesController,
              focusNode: widget.chronicDiseasesFocusNode,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();  // Hide keyboard or move focus elsewhere if needed
              },
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}
