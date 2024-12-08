import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';
import '../languages.dart';
import '../models/user_details.dart';
import '../registration/countries.dart';

class EditProfilePage extends StatefulWidget {
  final Data userData;

  const EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final UserController UserInfoController = Get.put(UserController());

  late TextEditingController _firstNameController;
  late TextEditingController _secondNameController;
  late TextEditingController _thirdNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _chronicDiseasesController;
  late TextEditingController _allergiesController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactPhoneController;
  late TextEditingController _birthYearController;
  late TextEditingController _countryController;
  late TextEditingController _provinceController;
  late TextEditingController _districtController;
  late TextEditingController _alleyController;
  late TextEditingController _houseController;
  late TextEditingController _emergencyContactAddressController;
  late TextEditingController _emergencyContactCountryController;
  late TextEditingController _emergencyContactProvinceController;
  late TextEditingController _emergencyContactDistrictController;
  late TextEditingController _emergencyContactAlleyController;
  late TextEditingController _emergencyContactHouseController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  int? _selectedGender;
  int? _selectedBloodType;
  int? _selectedEmergencyContactRelationship;
  bool _isLoading = false;

  final Color _primaryColor = Color(0xFf259e9f);
  final Color _secondaryColor = Color(0xFf259e9f);
  final Color _accentColor = Color(0xFFE0FBFC);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController =
        TextEditingController(text: widget.userData.user?.firstName);
    _secondNameController =
        TextEditingController(text: widget.userData.user?.secondName);
    _thirdNameController =
        TextEditingController(text: widget.userData.user?.thirdName);
    _emailController = TextEditingController(text: widget.userData.user?.email);
    _phoneController =
        TextEditingController(text: widget.userData.user?.phoneNumber);
    _addressController = TextEditingController(text: widget.userData.address);
    _chronicDiseasesController =
        TextEditingController(text: widget.userData.chronicDiseases);
    _allergiesController =
        TextEditingController(text: widget.userData.allergies);
    _emergencyContactNameController =
        TextEditingController(text: widget.userData.emergencyContactFullName);
    _emergencyContactPhoneController = TextEditingController(
        text: widget.userData.emergencyContactPhoneNumber);
    _birthYearController =
        TextEditingController(text: widget.userData.birthYear?.toString());
    _countryController = TextEditingController(text: widget.userData.country);
    _provinceController = TextEditingController(text: widget.userData.province);
    _districtController = TextEditingController(text: widget.userData.district);
    _alleyController = TextEditingController(text: widget.userData.alley);
    _houseController = TextEditingController(text: widget.userData.house);
    _emergencyContactAddressController =
        TextEditingController(text: widget.userData.emergencyContactAddress);
    _emergencyContactCountryController =
        TextEditingController(text: widget.userData.emergencyContactCountry);
    _emergencyContactProvinceController =
        TextEditingController(text: widget.userData.emergencyContactProvince);
    _emergencyContactDistrictController =
        TextEditingController(text: widget.userData.emergencyContactDistrict);
    _emergencyContactAlleyController =
        TextEditingController(text: widget.userData.emergencyContactAlley);
    _emergencyContactHouseController =
        TextEditingController(text: widget.userData.emergencyContactHouse);
    _usernameController =
        TextEditingController(text: widget.userData.user?.username);
    _passwordController =
        TextEditingController();

    _selectedGender = widget.userData.gender;
    _selectedBloodType = widget.userData.bloodType;
    _selectedEmergencyContactRelationship =
        widget.userData.emergencyContactRelationship;
  }
  final List<Map<String, String>> countryOptions = [
    {'id': '1', 'name': 'iraq'.tr},
    {'id': '2', 'name': 'other_country'.tr}
  ];

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
  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _selectedGender = widget.userData.gender ?? 1;
    _selectedBloodType = widget.userData.bloodType ?? 1;
    _selectedEmergencyContactRelationship = widget.userData.emergencyContactRelationship ?? 1;
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _chronicDiseasesController.dispose();
    _allergiesController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _birthYearController.dispose();
    _countryController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _alleyController.dispose();
    _houseController.dispose();
    _emergencyContactAddressController.dispose();
    _emergencyContactCountryController.dispose();
    _emergencyContactProvinceController.dispose();
    _emergencyContactDistrictController.dispose();
    _emergencyContactAlleyController.dispose();
    _emergencyContactHouseController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      print('بدء عملية التحديث...');

      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print('تم جلب SharedPreferences بنجاح.');

        final String? jwtToken = prefs.getString('token');
        if (jwtToken == null) {
          throw Exception('JWT token is missing');
        }
        print('تم جلب JWT token بنجاح.');
        final Map<String, dynamic> requestBody = {
          "firstName": _firstNameController.text,
          "secondName": _secondNameController.text,
          "thirdName": _thirdNameController.text,
          "gender": _selectedGender ?? 1,
          "address": _addressController.text,
          "birthYear": _birthYearController.text,
          "country": _countryController.text,
          "province": _provinceController.text,
          "district": _districtController.text,
          "alley": _alleyController.text,
          "house": _houseController.text,
          "bloodType": _selectedBloodType ?? 1,
          "emergencyContactRelationship": _selectedEmergencyContactRelationship ?? 1,
          "email": _emailController.text,
          "chronicDiseases": _chronicDiseasesController.text,
          "allergies": _allergiesController.text,
          "emergencyContactFullName": _emergencyContactNameController.text,
          "emergencyContactAddress": _emergencyContactAddressController.text,
          "emergencyContactCountry": _emergencyContactCountryController.text,
          "emergencyContactProvince": _emergencyContactProvinceController.text,
          "emergencyContactDistrict": _emergencyContactDistrictController.text,
          "emergencyContactAlley": _emergencyContactAlleyController.text,
          "emergencyContactHouse": _emergencyContactHouseController.text,
          "emergencyContactPhoneNumber": _emergencyContactPhoneController.text,
          "phoneNumber": _phoneController.text,
          "username": _usernameController.text,
          "password": _passwordController.text.isNotEmpty ? _passwordController.text : ""
        };
        print('تم تجهيز البيانات المرسلة: $requestBody');
        final response = await http.put(
          Uri.parse('https://medicalpoint-api.tatwer.tech/api/Mobile/UpdatePatientDetails'),
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
          },
          body:json.encode(requestBody),
        );
        print('request_sent_success'.tr);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          UserInfoController.fetchPatientDetails();
          print('profile_update_success'.tr);
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('profile_update_success'.tr,style: TextStyle(color: Colors.white),),
              backgroundColor: Color(0xFF259E9F),
            ),
          );
          Navigator.pop(context, true);
        } else {
          print('فشل التحديث: ${response.body}');
          throw Exception('فشل تحديث الملف الشخصي: ${response.body}');
        }
      } catch (e) {
        print('خطأ أثناء تحديث الملف الشخصي: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('profile_update_error: $e'.tr)),
        );
      } finally {
        print('تم إنهاء عملية التحديث.');
        setState(() => _isLoading = false);
      }
    } else {
      print('التحقق من النموذج فشل.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar:AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF259E9F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'edit_personal_information'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Directionality(
          textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Column(
            children: [
              Expanded(
                child: _isLoading
                    ? Center(
                    child: CircularProgressIndicator(color: _primaryColor))
                    : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                            "personal_info".tr),
                        _buildTextField(
                          controller: _firstNameController,
                          labelText:"first_name".tr,
                        ),
                        _buildTextField(
                          controller: _secondNameController,
                          labelText: "middle_name".tr,
                        ),
                        _buildTextField(
                          controller: _thirdNameController,
                          labelText: "last_name".tr,
                        ),


                        _buildTextField(
                          controller: _birthYearController,
                          labelText:"age".tr,
                        ),
                        _buildCountryDropdown(
                          controller: _countryController,
                          labelText: "country".tr,
                        ),
                        _buildProvinceDropdown(),
                        _buildTextField(
                          controller: _districtController,
                          labelText: "district".tr,
                        ),
                        _buildTextField(
                          controller: _alleyController,
                          labelText: "المحلة",
                        ),
                        _buildTextField(
                          controller: _houseController,
                          labelText: "alley".tr,
                        ),
                        _buildDropdown(
                          value: _selectedGender == 0 ? 1 : _selectedGender,
                          label: "gender".tr,
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_translateGender(1)),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_translateGender(2)),
                            ),
                          ],
                          onChanged: (value) => setState(() => _selectedGender = value ?? 1),
                        ),

                        SizedBox(height: 20),
                        _buildSectionHeader(
                            "medical_info".tr
                        ),
                        _buildDropdown(
                          value: _selectedBloodType == 0 ? 1 : _selectedBloodType,
                          label: "blood_type".tr,
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_translateBloodType(1)),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_translateBloodType(2)),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_translateBloodType(3)),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(_translateBloodType(4)),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text(_translateBloodType(5)),
                            ),
                            DropdownMenuItem(
                              value: 6,
                              child: Text(_translateBloodType(6)),
                            ),
                            DropdownMenuItem(
                              value: 7,
                              child: Text(_translateBloodType(7)),
                            ),
                            DropdownMenuItem(
                              value: 8,
                              child: Text(_translateBloodType(8)),
                            ),
                          ],
                          onChanged: (value) => setState(() => _selectedBloodType = value ?? 1),
                        ),
                        _buildTextField(
                          controller: _chronicDiseasesController,
                          labelText: "chronic_diseases".tr,
                        ),
                        _buildTextField(
                          controller: _allergiesController,
                          labelText: "allergies".tr,
                        ),
                        SizedBox(height: 20),
                        _buildSectionHeader("emergency_contact".tr),
                        _buildTextField(
                          controller: _emergencyContactNameController,
                          labelText: 'emergencyContactPage.fullName'.tr,
                        ),
                        IntlPhoneField(
                          initialValue : _emergencyContactPhoneController.text,
                          decoration: InputDecoration(
                            labelText: "phone_number".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          ),
                          initialCountryCode: 'IQ',
                          textAlign: TextAlign.right,
                          invalidNumberMessage: 'invalid_phone'.tr,
                          onChanged: (phone) {
                            _emergencyContactPhoneController.text = phone.completeNumber;
                            print(phone.completeNumber);
                          },
                        ),
                        _buildCountryDropdown(
                          controller: _emergencyContactCountryController,
                          labelText: "country".tr,
                        ),
                        _buildEmergencyContactProvinceDropdown(),
                        _buildTextField(
                          controller: _emergencyContactDistrictController,
                          labelText:"district".tr,
                        ), _buildTextField(
                          controller: _emergencyContactAlleyController,
                          labelText:"المحلة",
                        ), _buildTextField(
                          controller: _emergencyContactHouseController,
                          labelText:"alley".tr,
                        ),
                        _buildDropdown(
                          value: _selectedEmergencyContactRelationship == 0 ? 1 : _selectedEmergencyContactRelationship,
                          label: "emergencyContactPage.relationship".tr,
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(_translateEmergencyContactRelationship(1)),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(_translateEmergencyContactRelationship(2)),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(_translateEmergencyContactRelationship(3)),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(_translateEmergencyContactRelationship(4)),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text(_translateEmergencyContactRelationship(5)),
                            ),
                            DropdownMenuItem(
                              value: 6,
                              child: Text(_translateEmergencyContactRelationship(6)),
                            ),
                            DropdownMenuItem(
                              value: 7,
                              child: Text(_translateEmergencyContactRelationship(7)),
                            ),
                            DropdownMenuItem(
                              value: 8,
                              child: Text(_translateEmergencyContactRelationship(8)),
                            ),
                            DropdownMenuItem(
                              value: 9,
                              child: Text(_translateEmergencyContactRelationship(9)),
                            ),
                          ],
                          onChanged: (value) => setState(() => _selectedEmergencyContactRelationship = value),
                        ),
                        SizedBox(height: 20),
                        _buildSectionHeader(
                            "contact_info".tr
                        ),
                        _buildTextField(
                          controller: _emailController,
                          labelText: "email".tr,
                        ),
                        IntlPhoneField(
                          initialValue : _phoneController.text,
                          decoration: InputDecoration(
                            labelText: "phone_number".tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _primaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          ),
                          initialCountryCode: 'IQ',
                          textAlign: TextAlign.right,
                          invalidNumberMessage: 'invalid_phone'.tr,
                          onChanged: (phone) {
                            _phoneController.text = phone.completeNumber;
                            print(phone.completeNumber);
                          },
                        ),
                        _buildTextField(
                          controller: _usernameController,
                          labelText: "username".tr,
                        ),
                        _buildTextField(
                          controller: _passwordController,
                          labelText: "password".tr,
                          obscureText: true,
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            child: Text('save_changes'.tr,style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ).animate().scale(
                              duration: 300.ms, curve: Curves.easeInOut),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
  Widget _buildCountryDropdown({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: CountryService.fetchCountries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: _primaryColor));
          } else if (snapshot.hasError) {
            return TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '${labelText} (Failed to load)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _primaryColor),
                ),
                errorText: 'Failed to load countries',
              ),
            );
          } else if (snapshot.hasData) {
            final uniqueCountries = <String>{};
            final filteredCountries = snapshot.data!
                .where((country) => uniqueCountries.add(country['name']))
                .toList();

            return DropdownButtonFormField<String>(
              value: filteredCountries.any((country) => country['name'] == controller.text)
                  ? controller.text
                  : null,
              isExpanded: true,
              items: filteredCountries.map((country) {
                return DropdownMenuItem<String>(
                  value: country['name'],
                  child: Text(
                    country['name']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                controller.text = value ?? '';
              },
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _primaryColor),
                ),
              ),
            );
          }
          return Container();
        },
      ).animate().fadeIn(duration: Duration(milliseconds: 500), delay: Duration(milliseconds: 100))
          .slideX(begin: 0.2, end: 0),
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _secondaryColor,
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0);
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _secondaryColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.edit,color: _primaryColor,),
            onPressed: () {
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideX(
        begin: 0.2, end: 0);
  }
Widget _buildProvinceDropdown() {
  return DropdownButtonFormField<String>(
    value: _provinceController.text.isNotEmpty ? _provinceController.text : null,
    decoration: InputDecoration(
      labelText: 'province'.tr,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    items: iraqGovernorates.map((governorate) {
      return DropdownMenuItem<String>(
        value: governorate['name'],
        child: Text(governorate['name']!),
      );
    }).toList(),
    onChanged: (newValue) {
      setState(() {
        _provinceController.text = newValue ?? '';
      });
    },
    icon: Icon(Icons.arrow_drop_down,
        color: _primaryColor),
    // validator: (value) {
    //   if (value == null || value.isEmpty) {
    //     return 'الرجاء اختيار المحافظة';
    //   }
    //   return null;
    // },
  );
}
Widget _buildEmergencyContactProvinceDropdown() {
  return DropdownButtonFormField<String>(
    value: _emergencyContactProvinceController.text.isNotEmpty
        ? _emergencyContactProvinceController.text
        : null,
    decoration: InputDecoration(
      labelText: 'province'.tr,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    items: iraqGovernorates.map((governorate) {
      return DropdownMenuItem<String>(
        value: governorate['name'],
        child: Text(governorate['name']!),
      );
    }).toList(),
    onChanged: (newValue) {
      setState(() {
        _emergencyContactProvinceController.text = newValue ?? '';
      });
    },
    icon: Icon(Icons.arrow_drop_down,
        color: _primaryColor),
    // validator: (value) {
    //   if (value == null || value.isEmpty) {
    //     return 'الرجاء اختيار المحافظة';
    //   }
    //   return null;
    // },
  );
}

  Widget _buildDropdown({
    required int? value,
    required String label,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _primaryColor),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
        items: items,
        onChanged: onChanged,
        icon: Icon(Icons.arrow_drop_down,
            color: _primaryColor),
        isExpanded: true,
        dropdownColor: _accentColor,
        style: TextStyle(color: _secondaryColor),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(
        begin: -0.2, end: 0);
  }
  String _translateBloodType(int? type) {
    if (type == null)  return 'not_specified'.tr;

    switch (type) {
      case 1:
        return "A+";
      case 2:
        return "A-";
      case 3:
        return "B+";
      case 4:
        return "B-";
      case 5:
        return "O+";
      case 6:
        return "O-";
      case 7:
        return "AB+";
      case 8:
        return "AB-";
      default:
        return 'not_specified'.tr;
    }
  }

  String _translateEmergencyContactRelationship(int? relationship) {
    if (relationship == null)         return 'not_specified'.tr;;

    switch (relationship) {
      case 1:
        return 'emergencyContactPage.father'.tr;
      case 2:
        return 'emergencyContactPage.mother'.tr;
      case 3:
        return 'emergencyContactPage.brother'.tr;
      case 4:
        return 'mergencyContactPage.sister'.tr;
      case 5:
        return 'emergencyContactPage.son'.tr;
      case 6:
        return 'emergencyContactPage.daughter';
      case 7:
        return 'emergencyContactPage.husband'.tr;
      case 8:
        return 'emergencyContactPage.wife'.tr;
      case 9:
        return 'emergencyContactPage.other'.tr;
      default:
        return 'not_specified'.tr;
    }
  }

  String _translateGender(int? gender) {
    if (gender == null)         return 'not_specified'.tr;;

    switch (gender) {
      case 1:
        return 'male'.tr;
      case 2:
        return 'female'.tr;
      default:
        return 'not_specified'.tr;
    }
  }
}