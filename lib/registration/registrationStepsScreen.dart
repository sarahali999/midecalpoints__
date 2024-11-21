import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:midecalpoints/registration/personalInfoPage.dart';
import '../mainscreen/homePage.dart';
import 'contactInfoPage.dart';
import 'emergencyContactPage.dart';
import 'medicalInfoPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationStepsScreen extends StatefulWidget {
  @override
  _RegistrationStepsScreenState createState() => _RegistrationStepsScreenState();
}

class _RegistrationStepsScreenState extends State<RegistrationStepsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final personalInfoKey = GlobalKey<FormState>();
  final medicalInfoKey = GlobalKey<FormState>();
  final emergencyContactKey = GlobalKey<FormState>();

  int? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fourthNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController governorateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController alleyController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController bloodTypeController = TextEditingController();
  TextEditingController chronicDiseasesController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController emergencyContactCountryController = TextEditingController();
  TextEditingController emergencyContactProvinceController = TextEditingController();
  TextEditingController emergencyContactDistrictController = TextEditingController();
  TextEditingController emergencyContactAlleyController = TextEditingController();
  TextEditingController emergencyContactHouseController = TextEditingController();
  TextEditingController emergencyContactNameController = TextEditingController();
  TextEditingController emergencyContactPhoneController = TextEditingController();
  TextEditingController emergencyContactAddressController = TextEditingController();
  TextEditingController emergencyContactRelationshipController = TextEditingController();
  List<TextEditingController> phoneControllers = [TextEditingController()];
  int selectedGender = 0;
  int selectedBloodType = 1;
  int currentStep = 0;

  final List<String> _titles = [
    "معلومات شخصية",
    "معلومات الاتصال",
    "معلومات طبية",
    "معلومات شخص مقرب"
  ];

  @override
  void initState() {
    super.initState();
  }Future<void> submitPatientData() async {
    try {
      if (phoneNumberController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('خطأ', 'يرجى ملء الحقول المطلوبة');
        return;
      } else {
        Get.snackbar(
          'نجاح',
          'تم إنشاء الحساب بنجاح',
          backgroundColor: Color(0xFf259e9f),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        await Future.delayed(Duration(seconds: 2));

        Get.offAll(() => MainScreen());
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          'https://medicalpoint-api.tatwer.tech/api/Mobile/RegisterPatient',
        ),
      );
      request.body = json.encode({
        'firstName': firstNameController.text,
        'secondName': lastNameController.text,
        'thirdName': middleNameController.text,
        'gender': selectedGender == 1 ? 0 : 1,
        'address': addressController.text,
        'birthYear': selectedYear ?? '',
        'country': countryController.text,
        'province': governorateController.text,
        'district': districtController.text,
        'alley': alleyController.text,
        'house': houseController.text,
        'bloodType': selectedBloodType,
        'email': emailController.text,
        'chronicDiseases': chronicDiseasesController.text,
        'allergies': allergiesController.text,
        'emergencyContactFullName': emergencyContactNameController.text,
        'emergencyContactAddress': emergencyContactAddressController.text,
        'emergencyContactCountry': emergencyContactCountryController.text,
        'emergencyContactProvince': emergencyContactProvinceController.text,
        'emergencyContactDistrict': emergencyContactDistrictController.text,
        'emergencyContactAlley': emergencyContactAlleyController.text,
        'emergencyContactHouse': emergencyContactHouseController.text,
        'emergencyContactPhoneNumber': emergencyContactPhoneController.text,
        'emergencyContactRelationship':
        int.tryParse(emergencyContactRelationshipController.text) ?? 0,
        'password': passwordController.text,
        'phoneNumber': phoneNumberController.text,
        'username': usernameController.text,
      });
      request.headers.addAll(headers);

      print('Request Body: ${request.body}');
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.size.height;
    double screenWidth = Get.size.width;
    double fontScale = screenWidth / 375;

    TextSpan textSpan = TextSpan(
      text: _titles[_currentPage],
      style: TextStyle(fontSize: 18 * fontScale, fontWeight: FontWeight.bold),
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    double textWidth = textPainter.size.width;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: screenHeight * 0.3,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xfffafbfb),
                      Color(0xFFecf2f3),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Get.width * 0.3),
                    bottomRight: Radius.circular(Get.width * 10),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Image.asset(
                  'assets/images/logo.png',
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  color: const Color(0xFf259e9f),
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.05, right: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تسجيل جديد',
                          style: TextStyle(
                            fontSize: 24 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'أنشئ حسابك بسهولة من خلال ملء بياناتك الكاملة',
                          style:
                          TextStyle(fontSize: 14 * fontScale, color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _titles[_currentPage],
                          style: TextStyle(
                            fontSize: 18 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: textWidth,
                          height: 2,
                          color: Color(0xFf259e9f),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      SingleChildScrollView(
                        child: PersonalInfoPage(
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          middleNameController: middleNameController,
                          alleyController: alleyController,
                          districtController: districtController,
                          governorateController: governorateController,
                          countryController: countryController,
                          houseController: houseController,
                          selectedGender: selectedGender,
                          selectedDay: selectedDay,
                          selectedMonth: selectedMonth,
                          selectedYear: selectedYear,
                          onGenderChanged: (value) =>
                              setState(() => selectedGender = value!),
                          onDayChanged: (value) =>
                              setState(() => selectedDay = int.parse(value!)),
                          onMonthChanged: (value) =>
                              setState(() => selectedMonth = value!),
                          onYearChanged: (value) => setState(() =>
                          selectedYear = value),
                        ),
                      ),
                      SingleChildScrollView(
                        child: ContactInfoPage(
                          phoneController: phoneNumberController,
                          emailController: emailController,
                          usernameController: usernameController,
                          passwordController: passwordController,
                        ),
                      ),
                      SingleChildScrollView(
                        child: MedicalInfoPage(
                          selectedBloodType: selectedBloodType,
                          chronicDiseasesController: chronicDiseasesController,
                          allergiesController: allergiesController,
                          onBloodTypeChanged: (value) =>
                              setState(() => selectedBloodType = value!),
                        ),
                      ),
                      SingleChildScrollView(
                        child: EmergencyContactPage(
                          emergencyContactNameController: emergencyContactNameController,
                          emergencyContactAddressController:
                          emergencyContactAddressController,
                          emergencyContactRelationshipController:
                          emergencyContactRelationshipController,
                          emergencyContactPhoneController:
                          emergencyContactPhoneController,
                          emergencyContactCountryController:
                          emergencyContactCountryController,
                          emergencyContactProvinceController:
                          emergencyContactProvinceController,
                          emergencyContactDistrictController:
                          emergencyContactDistrictController,
                          emergencyContactAlleyController:
                          emergencyContactAlleyController,
                          emergencyContactHouseController:
                          emergencyContactHouseController,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.15),
              ],
            ),
            Positioned(
              bottom: screenHeight * 0.1,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(index);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Color(0xFf259e9f) : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.03,
              right: screenWidth * 0.05,
              left: screenWidth * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFf259e9f),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_currentPage < 3) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    submitPatientData();
                  }
                },
                child: Text(
                  _currentPage < 3 ? "التالي" : "إنهاء",
                  style: TextStyle(fontSize: 18 * fontScale, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}