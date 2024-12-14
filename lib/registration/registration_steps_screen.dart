import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:midecalpoints/registration/personal_info_page.dart';
import '../languages.dart';
import '../login/verification.dart';
import 'contact_info_page.dart';
import 'emergency_contact_page.dart';
import 'medical_info_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationStepsScreen extends StatefulWidget {
  @override
  _RegistrationStepsScreenState createState() => _RegistrationStepsScreenState();
}

class _RegistrationStepsScreenState extends State<RegistrationStepsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isRTL = true;
  int selectedRelationship = 0;
  int _selectedGender = 0;
  int _selectedBloodType = 0;

  final personalInfoKey = GlobalKey<FormState>();
  final medicalInfoKey = GlobalKey<FormState>();
  final emergencyContactKey = GlobalKey<FormState>();
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
  List<TextEditingController> phoneControllers = [TextEditingController()];
  int currentStep = 0;
  final List<String> _titles = [
    'personal_info'.tr,
    'medical_info'.tr,
    'emergency_contact'.tr,
    'contact_info'.tr,
  ];

  @override
  void initState() {
    super.initState();
    isRTL = Languages.isRTL(Get.locale?.languageCode ?? 'en');

  }
  bool _isLoading = false;

  Future<void> submitPatientData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (phoneNumberController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar(
          'error'.tr,
          'fill_required_fields'.tr,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
        return;

      }


      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          'https://medicalpoint-api.tatwer.tech/api/Mobile/RegisterPatient',
        ),
      );

      var requestBody = {
        'firstName': firstNameController.text,
        'secondName': lastNameController.text,
        'thirdName': middleNameController.text,
        'gender': _selectedGender,
        'bloodType': _selectedBloodType,
        'address': addressController.text,
        'birthYear': selectedYear ?? '',
        'country': countryController.text,
        'province': governorateController.text,
        'district': districtController.text,
        'alley': alleyController.text,
        'house': houseController.text,
        'email': emailController.text,
        'chronicDiseases': chronicDiseasesController.text,
        'allergies': allergiesController.text,
        'emergencyContactFullName': emergencyContactNameController.text,
        'emergencyContactCountry': emergencyContactCountryController.text,
        'emergencyContactProvince': emergencyContactProvinceController.text,
        'emergencyContactDistrict': emergencyContactDistrictController.text,
        'emergencyContactAlley': emergencyContactAlleyController.text,
        'emergencyContactHouse': emergencyContactHouseController.text,
        'emergencyContactPhoneNumber': emergencyContactPhoneController.text,
        'emergencyContactRelationship': selectedRelationship,
        'password': passwordController.text,
        'phoneNumber': phoneNumberController.text,
        'username': usernameController.text,
      };
      request.body = json.encode(requestBody);
      request.headers.addAll(headers);
      print('Request URL: ${request.url}');
      print('Request Headers: ${request.headers}');
      print('Request Body: ${request.body}');

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration Successful');
        Get.snackbar(
          'success'.tr,
          'registration_success'.tr,
          backgroundColor: Color(0xFf259e9f),
          colorText: Colors.white,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login())
        );
      } else {
        Map<String, dynamic> errorResponse = json.decode(responseBody);
        String errorMessage = errorResponse['message'] ?? 'unknown_error'.tr;
        if (errorMessage.toLowerCase().contains('phone') ||
            errorMessage.toLowerCase().contains('already exists')) {
          Get.snackbar(
            'error'.tr,
            'رقم الهاتف موجود مسبقا',
            backgroundColor: Colors.red[400],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          setState(() {
            _isLoading = false;
          });
        } else {
          Get.snackbar(
            'error'.tr,
            errorMessage,
            backgroundColor: Colors.red[400],
            colorText: Colors.white,
          );

          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    catch (e, stackTrace) {
      print('Exception occurred during registration: $e');
      Get.snackbar(
        'error'.tr,
        'something_went_wrong'.tr,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );

      setState(() {
        _isLoading = false;
      });
    }
  }
  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0: // Personal Info Page
        if (firstNameController.text.isEmpty ||
            lastNameController.text.isEmpty ||
            _selectedGender == 0 ||
            countryController.text.isEmpty ||
            selectedYear == null) {
          Get.snackbar(
            'error'.tr,
            'fill_required_fields'.tr,
            backgroundColor: Colors.red[400],
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 1:
        if (_selectedBloodType == 0) {
          Get.snackbar(
            'error'.tr,
            'fill_required_fields'.tr,
            backgroundColor: Colors.red[400],
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      case 2:
        if (emergencyContactNameController.text.isEmpty ||
            emergencyContactPhoneController.text.isEmpty ||
            selectedRelationship == 0) {
          Get.snackbar(
            'error'.tr,
            'fill_required_fields'.tr,
            backgroundColor: Colors.red[400],
            colorText: Colors.white,
          );
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

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

    return WillPopScope(
        onWillPop: () async {
          if (_currentPage > 0) {
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            return false;
          } else {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.amber,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'alert'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'cancel_registration_confirm'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'no'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: Colors.red[500],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'yes'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
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
            return shouldPop ?? false;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false, // إضافة هذا السطر

          body: Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: Stack(
              children: [
                Positioned.fill(
                  left: 0,
                  right: 0,
                  bottom: screenHeight * 0.3,
                  top: 0,
                  child: Directionality(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                ),

                Positioned(
                  top: screenHeight * 0.05,
                  left: isRTL ? null : screenWidth * 0.05,
                  right: isRTL ? screenWidth * 0.05 : null,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xFf259e9f),
                      size: 24 * fontScale,
                    ),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.amber,
                                          size: 28,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'تنبيه'.tr,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'هل تريد إلغاء عملية التسجيل؟'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12),
                                              backgroundColor: Colors.grey[100],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'لا'.tr,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12),
                                              backgroundColor: Colors.red[500],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'نعم'.tr,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
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
                    },
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
                      alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.05,
                          right: isRTL ? screenWidth * 0.04 : 0,
                          left: isRTL ? 0 : screenWidth * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                              child: Text(
                                'new_registration'.tr,
                                style: TextStyle(
                                  fontSize: 24 * fontScale,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'create_account_easily'.tr,
                              style: TextStyle(fontSize: 14 * fontScale, color: Colors.grey),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Align(
                        alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                          if (index > _currentPage) {
                            if (!_validateCurrentPage()) {
                              _pageController.jumpToPage(_currentPage);
                              return;
                            }
                          }

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
                              selectedGender: _selectedGender,
                              onGenderChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedGender = value;
                                  }
                                  );
                                }
                              },

                              selectedYear: selectedYear,

                              onYearChanged: (value) => setState(() =>
                              selectedYear = value),
                            ),
                          ),
                          SingleChildScrollView(
                            child: MedicalInfoPage(
                              selectedBloodType: _selectedBloodType,
                              onBloodTypeChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedBloodType = value;
                                  });
                                }
                              },
                              chronicDiseasesController: chronicDiseasesController,
                              allergiesController: allergiesController,
                            ),
                          ),
                          SingleChildScrollView(
                            child:EmergencyContactPage(
                              emergencyContactNameController: emergencyContactNameController,
                              emergencyContactRelationship: selectedRelationship,
                              onRelationshipChanged: (int newRelationship) {
                                setState(() {
                                  selectedRelationship = newRelationship;
                                });
                              },
                              emergencyContactPhoneController: emergencyContactPhoneController,
                              emergencyContactCountryController: emergencyContactCountryController,
                              emergencyContactProvinceController: emergencyContactProvinceController,
                              emergencyContactDistrictController: emergencyContactDistrictController,
                              emergencyContactAlleyController: emergencyContactAlleyController,
                              emergencyContactHouseController: emergencyContactHouseController,
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
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.15),
                  ],
                ),
                  AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
    bottom: isKeyboardVisible ? -50 : screenHeight * 0.1,
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

    // Final Button
    AnimatedPositioned(
    duration: Duration(milliseconds: 200),
      bottom: isKeyboardVisible ? -screenHeight : screenHeight * 0.03, // التعديل هنا
    right: screenWidth * 0.05,
    left: screenWidth * 0.05,
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: _currentPage < 3
    ? const Color(0xFf259e9f)
        : (_isLoading ? Colors.grey : const Color(0xFf259e9f)),
    padding: EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    onPressed: _currentPage < 3
    ? () {
    if (_validateCurrentPage()) {
    _pageController.nextPage(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    );
    }
    }
        : (_isLoading ? null : submitPatientData),
    child: _isLoading && _currentPage == 3
    ? SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(
    color: Colors.white,
    strokeWidth: 3,
    ),
    )
        : Text(
    _currentPage < 3 ? 'next'.tr : 'finish'.tr,
    style: TextStyle(
    fontSize: 16 * fontScale,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    )
    );
  }
}