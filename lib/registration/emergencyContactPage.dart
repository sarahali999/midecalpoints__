import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'Countries.dart';
import 'custom.dart';

class EmergencyContactPage extends StatefulWidget {
  final TextEditingController emergencyContactNameController;
  final TextEditingController emergencyContactAddressController;
  final TextEditingController emergencyContactRelationshipController;
  final TextEditingController emergencyContactPhoneController;
  final TextEditingController emergencyContactCountryController;
  final TextEditingController emergencyContactProvinceController;
  final TextEditingController emergencyContactDistrictController;
  final TextEditingController emergencyContactAlleyController;
  final TextEditingController emergencyContactHouseController;

  const EmergencyContactPage({
    required this.emergencyContactNameController,
    required this.emergencyContactAddressController,
    required this.emergencyContactRelationshipController,
    required this.emergencyContactPhoneController,
    required this.emergencyContactCountryController,
    required this.emergencyContactProvinceController,
    required this.emergencyContactDistrictController,
    required this.emergencyContactAlleyController,
    required this.emergencyContactHouseController,
    Key? key,
  }) : super(key: key);

  @override
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}


class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emergencycountryController = TextEditingController();
  final TextEditingController emergencygovernorateController = TextEditingController();
  final TextEditingController emergencydistrictController = TextEditingController();
  final TextEditingController emergencyalleyController = TextEditingController();
  final TextEditingController emergencyhouseController = TextEditingController();
  final TextEditingController emergencybirthYearController = TextEditingController();
  final TextEditingController emergencyphoneNumberController = TextEditingController();
  String initialCountryCode = 'IQ';
  String completePhoneNumber = '';

  final Map<String, int> relationshipOptions = {
    'اب': 1,
    'ام': 2,
    'اخ': 3,
    'اخت': 4,
    'ابن': 5,
    'ابنه': 6,
    'زوج': 7,
    'زوجة': 8,
    'اخرى': 9,
  };

  String selectedRelationship = 'اب';

  String cntr = "";
  final List<Map<String, String>> countryOptions = [
    {'id': '1', 'name': 'العراق'},
    {'id': '2', 'name': 'اخرى'}
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
          emergencycountryController.text = 'العراق';
        } else {
          emergencycountryController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    double spacing = screenHeight * 0.02;
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: spacing);

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                labelText: 'emergencyContactPage.fullName'.tr,
                controller: fullNameController
            ),
            SizedBox(height: spacing),
            DropdownButtonFormField<String>(
              hint: Text('emergencyContactPage.selectCountry'.tr),
              value: selectedCountry,
              items: countryOptions.map((item) => DropdownMenuItem<String>(
                value: item['id'],
                child: Text(
                  item['name']!,
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
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      controller: emergencycountryController,
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
                        emergencygovernorateController.text = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'emergencyContactPage.province'.tr,
                      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color(0xFFd6dedf),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.district'.tr,
                    controller: emergencydistrictController,
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.alley'.tr,
                    controller: emergencyalleyController,
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.house'.tr,
                    controller: emergencyhouseController,
                  ),
                ],
              )
            else if (selectedCountry == '2')
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final countries = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      value: emergencycountryController.text.isNotEmpty ? emergencycountryController.text : null,
                      items: countries.map((country) {
                        return DropdownMenuItem<String>(
                          value: country['name'],
                          child: Text(
                            country['name']!,
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          emergencycountryController.text = value ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'emergencyContactPage.country'.tr,
                        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Color(0xFFd6dedf),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                    );
                  }
                },
              ),
            SizedBox(height: spacing),
            CustomTextField(
                labelText: 'emergencyContactPage.birthYear'.tr,
                controller: emergencybirthYearController
            ),
            SizedBox(height: spacing),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'emergencyContactPage.relationship'.tr,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Color(0xFFd6dedf),
              ),
              value: selectedRelationship,
              items: relationshipOptions.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRelationship = newValue!;
                });
              },
            ),
            SizedBox(height: spacing),
            IntlPhoneField(
              controller: emergencyphoneNumberController,
              decoration: InputDecoration(
                labelText: 'emergencyContactPage.phoneNumber'.tr,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Color(0xFFd6dedf),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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