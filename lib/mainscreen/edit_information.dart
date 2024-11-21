import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserDetails.dart';
import '../registration/Countries.dart';

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
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? jwtToken = prefs.getString('token');

        if (jwtToken == null) {
          throw Exception('JWT token is missing');
        }

        final Map<String, dynamic> requestBody = {
          "firstName": _firstNameController.text,
          "secondName": _secondNameController.text,
          "thirdName": _thirdNameController.text,
          "gender": _selectedGender,
          "address": _addressController.text,
          "birthYear": _birthYearController.text,
          "country": _countryController.text,
          "province": _provinceController.text,
          "district": _districtController.text,
          "alley": _alleyController.text,
          "house": _houseController.text,
          "bloodType": _selectedBloodType,
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
          "emergencyContactRelationship": _selectedEmergencyContactRelationship,
          "phoneNumber": _phoneController.text,
          "username": _usernameController.text,
        };

        if (_passwordController.text.isNotEmpty) {
          requestBody["password"] = _passwordController.text;
        }

        final response = await http.put(
          Uri.parse(
              'https://medicalpoint-api.tatwer.tech/api/Mobile/UpdatePatientDetails'),
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception('فشل تحديث الملف الشخصي: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحديث الملف الشخصي: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFf259e9f),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "تعديل المعلومات الشخصية",
            style: TextStyle(
              fontSize: 18,

              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
                        icon: Icons.person,
                      ),
                      _buildTextField(
                        controller: _secondNameController,
                        labelText: "الاسم الثاني",
                        icon: Icons.person_outline,
                      ),
                      _buildTextField(
                        controller: _thirdNameController,
                        labelText: "الاسم الثالث",
                        icon: Icons.person_outline,
                      ),
                      _buildTextField(
                        controller: _emailController,
                        labelText: "البريد الالكتروني",
                        icon: Icons.email,
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        labelText:"رقم الهاتف",
                        icon: Icons.phone,
                      ),
                      _buildTextField(
                        controller: _addressController,
                        labelText: "العنوان",
                        icon: Icons.home,
                      ),
                      _buildTextField(
                        controller: _birthYearController,
                        labelText:"العمر",
                        icon: Icons.cake,
                      ),
                      _buildCountryDropdown(
                        controller: _countryController,
                        labelText: "البلد",
                        icon: Icons.flag,
                      ),
                      _buildTextField(
                        controller: _provinceController,
                        labelText: "المحافظة",
                        icon: Icons.location_city,
                      ),
                      _buildTextField(
                        controller: _districtController,
                        labelText: "المحلة",
                        icon: Icons.location_on,
                      ),
                      _buildTextField(
                        controller: _alleyController,
                        labelText: "الزقاق",
                        icon: Icons.streetview,
                      ),
                      _buildTextField(
                        controller: _houseController,
                        labelText: "الدار",
                        icon: Icons.house,
                      ),
                      _buildAnimatedDropdown(
                        value: _selectedGender,
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
                        onChanged: (value) => setState(() => _selectedGender = value),
                        icon: Icons.wc,
                      ),
                      SizedBox(height: 20),
                      _buildSectionHeader(
                          "المعلومات الطبية"
                      ),
                      _buildAnimatedDropdown(
                        value: _selectedBloodType,
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
                        ],
                        onChanged: (value) => setState(() => _selectedBloodType = value),
                        icon: Icons.bloodtype,
                      ),
                      _buildCountryDropdownem(

                        controller: _emergencyContactCountryController,
                        labelText:"البلد",
                        icon: Icons.flag,
                      ),
                      _buildTextField(
                        controller: _chronicDiseasesController,
                        labelText: "الامراض المزمنة",
                        icon: Icons.medical_services,
                      ),
                      _buildTextField(
                        controller: _allergiesController,
                        labelText: "الحساسية",
                        icon: Icons.warning,
                      ),
                      SizedBox(height: 20),
                      _buildSectionHeader("معلومات الاتصال الطارئة"),
                      _buildTextField(
                        controller: _emergencyContactNameController,
                        labelText: "اسمه",
                        icon: Icons.contact_emergency,
                      ),
                      _buildTextField(
                        controller: _emergencyContactPhoneController,
                        labelText: "رقم هاتفه",
                        icon: Icons.phone_callback,
                      ),
                      _buildTextField(
                        controller: _emergencyContactAddressController,
                        labelText: "العنوان",
                        icon: Icons.home_work,
                      ),
                      _buildCountryDropdown(
                        controller: _emergencyContactCountryController,
                        labelText: "البلد",
                        icon: Icons.flag,
                      ),
                      _buildTextField(
                        controller: _emergencyContactProvinceController,
                        labelText: "المحافظة",
                        icon: Icons.location_city,
                      ),
                      _buildTextField(
                        controller: _emergencyContactDistrictController,
                        labelText:"المحلة",
                        icon: Icons.location_on,
                      ),
                      // _buildAnimatedDropdown(
                      //   value: _selectedEmergencyContactRelationship,
                      //   label: "صلة القرابة",
                      //   items: [
                      //     DropdownMenuItem(
                      //       value: 1,
                      //       child: Text(_translateEmergencyContactRelationship(1)),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 2,
                      //       child: Text(_translateEmergencyContactRelationship(2)),
                      //     ),
                      //   ],
                      //   onChanged: (value) => setState(() => _selectedEmergencyContactRelationship = value),
                      //   icon: Icons.people_outline_outlined,
                      // ),
                      SizedBox(height: 20),
                      _buildSectionHeader(
                          "معلومات الحساب"),
                      _buildTextField(
                        controller: _usernameController,
                        labelText: "اسم المستخدم",
                        icon: Icons.account_circle,
                      ),
                      _buildTextField(
                        controller: _passwordController,
                        labelText: "كلمة السر",
                        icon: Icons.lock,
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
    required IconData icon,
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
                prefixIcon: Icon(icon, color: _primaryColor),
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
            final countries = snapshot.data!;
            return DropdownButtonFormField<String>(
              value: controller.text.isNotEmpty ? controller.text : null,
              isExpanded: true,

              items: countries.map((country) {
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
                prefixIcon: Icon(icon, color: _primaryColor),
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
      ),
    ).animate().fadeIn(duration: Duration(milliseconds: 500), delay: Duration(milliseconds: 100))
        .slideX(begin: 0.2, end: 0);
  }
  Widget _buildCountryDropdownem({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
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
                prefixIcon: Icon(icon, color: _primaryColor),
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
            final countries = snapshot.data!;
            return DropdownButtonFormField<String>(
              value: controller.text.isNotEmpty ? controller.text : null,
              isExpanded: true,

              items: countries.map((country) {
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
                prefixIcon: Icon(icon, color: _primaryColor),
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
      ),
    ).animate().fadeIn(duration: Duration(milliseconds: 500), delay: Duration(milliseconds: 100))
        .slideX(begin: 0.2, end: 0);
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
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: _primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _primaryColor),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideX(
        begin: 0.2, end: 0);
  }
  Widget _buildAnimatedDropdown({
    required int? value,
    required String label,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _primaryColor),
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