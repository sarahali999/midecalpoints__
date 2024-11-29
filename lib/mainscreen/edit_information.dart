import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _selectedGender = widget.userData.gender ?? 1; // Provide a default value
    _selectedBloodType = widget.userData.bloodType ?? 1; // Provide a default value
    _selectedEmergencyContactRelationship = widget.userData.emergencyContactRelationship ?? 1; // Provide a default value
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
          "gender": _selectedGender ?? 1, // Ensure it's never 0
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
          body: json.encode(requestBody),
        );

        print('تم إرسال الطلب بنجاح.');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          print('تم تحديث الملف الشخصي بنجاح.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
          );
          Navigator.pop(context, true);
        } else {
          print('فشل التحديث: ${response.body}');
          throw Exception('فشل تحديث الملف الشخصي: ${response.body}');
        }
      } catch (e) {
        print('خطأ أثناء تحديث الملف الشخصي: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحديث الملف الشخصي: $e')),
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
    return Scaffold(
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
          'تعديل المعلومات الشخصية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
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
                          "المعلومات الشخصية"),
                      _buildTextField(
                        controller: _firstNameController,
                        labelText:"الاسم الاول",
                      ),
                      _buildTextField(
                        controller: _secondNameController,
                        labelText: "الاسم الثاني",
                      ),
                      _buildTextField(
                        controller: _thirdNameController,
                        labelText: "الاسم الثالث",
                      ),


                      _buildTextField(
                        controller: _birthYearController,
                        labelText:"العمر",
                      ),
                      _buildCountryDropdown(
                        controller: _countryController,
                        labelText: "البلد",
                      ),
                      _buildTextField(
                        controller: _provinceController,
                        labelText: "المحافظة",),
                      _buildTextField(
                        controller: _districtController,
                        labelText: "المحلة",
                      ),
                      _buildTextField(
                        controller: _alleyController,
                        labelText: "الزقاق",
                      ),
                      _buildTextField(
                        controller: _houseController,
                        labelText: "الدار",
                      ),
                      _buildDropdown(
                        value: _selectedGender == 0 ? 1 : _selectedGender,
                        label: "الجنس",
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
                          "المعلومات الطبية"
                      ),
                      _buildDropdown(
                        value: _selectedBloodType == 0 ? 1 : _selectedBloodType,
                        label: "فصيلة الدم",
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
                        labelText: "الامراض المزمنة",
                      ),
                      _buildTextField(
                        controller: _allergiesController,
                        labelText: "الحساسية",
                      ),
                      SizedBox(height: 20),
                      _buildSectionHeader("معلومات الاتصال الطارئة"),
                      _buildTextField(
                        controller: _emergencyContactNameController,
                        labelText: "اسمه",
                      ),
                      _buildTextField(
                        controller: _emergencyContactPhoneController,
                        labelText: "رقم هاتفه",
                      ),
                      _buildCountryDropdown(
                        controller: _emergencyContactCountryController,
                        labelText: "البلد",
                      ),
                      _buildTextField(
                        controller: _emergencyContactProvinceController,
                        labelText: "المحافظة",
                      ),
                      _buildTextField(
                        controller: _emergencyContactDistrictController,
                        labelText:"المحلة",
                      ),
                      _buildDropdown(
                        value: _selectedEmergencyContactRelationship == 0 ? 1 : _selectedEmergencyContactRelationship,
                        label: "صلة القرابة",
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
                          "معلومات الحساب"
                      ),
                      _buildTextField(
                        controller: _emailController,
                        labelText: "البريد الالكتروني",
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        labelText:"رقم الهاتف",
                      ),
                      _buildTextField(
                        controller: _usernameController,
                        labelText: "اسم المستخدم",
                      ),
                      _buildTextField(
                        controller: _passwordController,
                        labelText: "كلمة السر",
                        obscureText: true,
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updateProfile,

                          child: Text("حفظ التغييرات",style: TextStyle(color: Colors.white),),
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
            // More robust deduplication using a Set
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a country';
                }
                return null;
              },
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
        icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
        isExpanded: true,
        dropdownColor: _accentColor,
        style: TextStyle(color: _secondaryColor),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(
        begin: -0.2, end: 0);
  }
  String _translateBloodType(int? type) {
    if (type == null) return "غير معروف";

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
        return "غير معروف";
    }
  }

  String _translateEmergencyContactRelationship(int? relationship) {
    if (relationship == null) return "غير معروف";

    switch (relationship) {
      case 1:
        return 'اب';
      case 2:
        return 'ام';
      case 3:
        return 'اخ';
      case 4:
        return 'اخت';
      case 5:
        return 'ابن';
      case 6:
        return 'ابنة';
      case 7:
        return 'زوج';
      case 8:
        return 'زوجة';
      case 9:
        return 'أخرى';
      default:
        return 'غير معروف';
    }
  }

  String _translateGender(int? gender) {
    if (gender == null) return "غير معروف";

    switch (gender) {
      case 1:
        return 'ذكر';
      case 2:
        return 'أنثى';
      default:
        return 'غير معروف';
    }
  }
}