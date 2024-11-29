import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'countries.dart';
import 'custom.dart';

class EmergencyContactPage extends StatefulWidget {
  final TextEditingController emergencyContactNameController;
  final TextEditingController emergencyContactPhoneController;
  final TextEditingController emergencyContactCountryController;
  final TextEditingController emergencyContactProvinceController;
  final TextEditingController emergencyContactDistrictController;
  final TextEditingController emergencyContactAlleyController;
  final TextEditingController emergencyContactHouseController;  final int emergencyContactRelationship;
  final Function(int) onRelationshipChanged;

   EmergencyContactPage({
     Key? key,
     required this.emergencyContactNameController,
     required this.emergencyContactPhoneController,
     required this.emergencyContactCountryController,
     required this.emergencyContactProvinceController,
     required this.emergencyContactDistrictController,
     required this.emergencyContactAlleyController,
     required this.emergencyContactHouseController,
     required this.emergencyContactRelationship,
     required this.onRelationshipChanged,
  }) : super(key: key);

  @override
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyContactCountryController = TextEditingController();
  final TextEditingController emergencyContactProvinceController = TextEditingController();
  final TextEditingController emergencyContactDistrictController = TextEditingController();
  final TextEditingController emergencyContactAlleyController = TextEditingController();
  final TextEditingController emergencyContactHouseController = TextEditingController();
  final TextEditingController emergencyContactPhoneController = TextEditingController();
  String initialCountryCode = 'IQ';
  String completePhoneNumber = '';
  final Map<String, int> relationshipOptions = {
    'غير معروف': 0,
    'emergencyContactPage.father'.tr: 1,
    'emergencyContactPage.mother'.tr: 2,
    'emergencyContactPage.brother'.tr: 3,
    'emergencyContactPage.sister'.tr: 4,
    'emergencyContactPage.son'.tr: 5,
    'emergencyContactPage.daughter'.tr: 6,
    'emergencyContactPage.husband'.tr: 7,
    'emergencyContactPage.wife'.tr: 8,
    'emergencyContactPage.other'.tr: 9,
  };
  String? _currentRelationship;

  @override
  void initState() {
    super.initState();
    _currentRelationship = widget.emergencyContactRelationship == 0 ? null : relationshipOptions.entries
        .firstWhere((entry) => entry.value == widget.emergencyContactRelationship)
        .key;
  }
  String cntr = "";
  final List<Map<String, String>> countryOptions = [
    {'id': '1', 'name': 'emergencyContactPage.iraq'.tr},
    {'id': '2', 'name': 'emergencyContactPage.other_country'.tr}
  ];
  String? selectedCountry;
  final List<Map<String, String>> iraqGovernorates = [
    {'id': '1', 'name': 'بغداد'},
    {'id': '2', 'name': 'البصرة'},
    {'id': '3', 'name': 'نينوى'},
    {'id': '4', 'name': 'الأنبار'},
    {'id': '5', 'name': 'بابل'},
    {'id': '6', 'name': 'ديالى'},
    {'id': '7', 'name': 'القادسية'},
    {'id': '8', 'name': 'ذي قار'},
    {'id': '9', 'name': 'السليمانية'},
    {'id': '10', 'name': 'صلاح الدين'},
    {'id': '11', 'name': 'كربلاء'},
    {'id': '12', 'name': 'كركوك'},
    {'id': '13', 'name': 'ميسان'},
    {'id': '14', 'name': 'المثنى'},
    {'id': '15', 'name': 'النجف'},
    {'id': '16', 'name': 'واسط'},
    {'id': '17', 'name': 'أربيل'},
    {'id': '18', 'name': 'دهوك'},
  ];
  String? selectedGovernorate;

  void _onCountryChanged(String? selectedCountry) {
    if (selectedCountry != null) {
      setState(() {
        this.selectedCountry = selectedCountry;
        if (selectedCountry == '1') {
          widget.emergencyContactCountryController.text = 'emergencyContactPage.iraq'.tr;
        } else {
         widget. emergencyContactCountryController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    double spacing = screenHeight * 0.02;
    EdgeInsets padding = EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05, vertical: spacing);

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                labelText: 'emergencyContactPage.fullName'.tr,
              controller: widget.emergencyContactNameController,
            ),
            SizedBox(height: spacing),
            DropdownButtonFormField<String>(
              hint: Text('emergencyContactPage.selectCountry'.tr),
              value: selectedCountry,
              items: countryOptions.map((item) =>
                  DropdownMenuItem<String>(
                    value: item['id'],
                    child: Text(
                      item['name']!.tr,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  )).toList(),
              onChanged: _onCountryChanged,
              decoration: InputDecoration(
                labelText: 'emergencyContactPage.country'.tr,
                labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Color(0xFFd6dedf),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
            ),
            SizedBox(height: spacing),

            if (selectedCountry == '1')
              Column(
                children: [
                  Visibility(
                    visible: false,
                    maintainState: true,
                    child: CustomTextField(
                      labelText: 'emergencyContactPage.country'.tr,
                      controller: widget.emergencyContactCountryController,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedGovernorate,
                    items: iraqGovernorates.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['name'],
                        child: Text(
                          item['name']!,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGovernorate = value;
                        widget. emergencyContactProvinceController.text = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'emergencyContactPage.province'.tr,
                      labelStyle: TextStyle(
                          color: Colors.grey[600], fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color(0xFFd6dedf),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.district'.tr,
                    controller: widget.emergencyContactDistrictController,
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.alley'.tr,
                    controller: widget.emergencyContactAlleyController,
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.house'.tr,
                    controller: widget.emergencyContactHouseController,
                  ),
                ],
              )
            else
              if (selectedCountry == '2')
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: CountryService.fetchCountries(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Center(
                          child: Text(
                            'emergencyContactPage.countriesError'.tr,
                            style: TextStyle(color: Colors.red, fontSize: 14
                            ),
                          ),
                        ),
                      );
                    }
                    else if (snapshot.hasData) {
                      final countries = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        value:widget. emergencyContactCountryController.text.isNotEmpty
                            ? widget.emergencyContactCountryController.text
                            : null,
                        items: countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country['name'],
                            child: Text(
                              country['name']!,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.emergencyContactCountryController.text = value ?? '';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'emergencyContactPage.country'.tr,
                          labelStyle: TextStyle(color: Colors.grey[600],
                              fontSize: 14),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Color(0xFFd6dedf),
                          contentPadding: EdgeInsets.symmetric(vertical: 16,
                              horizontal: 16),
                        ),
                      );
                    } else {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: Text(
                            'emergencyContactPage.noCountries'.tr,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ),
                      );
                    }
                  },
                ),
            SizedBox(height: spacing),
    DropdownButtonFormField<String>(
    value: _currentRelationship,
    hint: Text('اختر صلة القرابة'), // نص تلميحي عندما لا يوجد اختيار
    decoration: InputDecoration(
    labelText: 'emergencyContactPage.relationship'.tr,
    border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10.0),
    ),
    filled: true,
    fillColor: Color(0xFFd6dedf),
    ),
    items: relationshipOptions.entries
        .where((entry) => entry.value != 0)
        .map((entry) {
    return DropdownMenuItem<String>(
    value: entry.key,
    child: Text(entry.key),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _currentRelationship = newValue;
    widget.onRelationshipChanged(newValue != null ? relationshipOptions[newValue]! : 0);
    });
    },
    ),


            SizedBox(height: spacing),
            IntlPhoneField(
              controller: widget.emergencyContactPhoneController,
              decoration: InputDecoration(
                labelText: 'emergencyContactPage.phoneNumber'.tr,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Color(0xFFd6dedf),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
              initialCountryCode: initialCountryCode,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              onChanged: (phone) {
                completePhoneNumber = phone.completeNumber;
              },
              onCountryChanged: (country) {
                setState(() {
                  initialCountryCode = country.code;
                });
              },
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}