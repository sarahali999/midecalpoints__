import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Countries.dart';
import 'custom.dart';

class PersonalInfoPage extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController middleNameController;
  final TextEditingController alleyController;
  final TextEditingController districtController;
  final TextEditingController governorateController;
  final TextEditingController countryController;
  final TextEditingController houseController;
  final int selectedGender;
  final int? selectedDay;
  final String? selectedMonth;
  final String? selectedYear;
  final Function(int?) onGenderChanged;
  final Function(String?) onDayChanged;
  final Function(String?) onMonthChanged;
  final Function(String?) onYearChanged;

  const PersonalInfoPage({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.middleNameController,
    required this.alleyController,
    required this.districtController,
    required this.governorateController,
    required this.countryController,
    required this.houseController,
    required this.selectedGender,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onGenderChanged,
    required this.onDayChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final Map<String, int> genderOptions = {
    'ذكر': 1,
    'أنثى': 2,
  };

  String? selectedCountry;
  String? selectedGovernorate;

  // Lists for date dropdowns
  final List<int> days = List.generate(31, (index) => index + 1);
  final List<String> months = [
    'كانون الثاني', 'شباط', 'آذار', 'نيسان', 'أيار', 'حزيران',
    'تموز', 'آب', 'أيلول', 'تشرين الأول', 'تشرين الثاني', 'كانون الأول'
  ];
  final List<String> years = List.generate(
      100,
          (index) => (DateTime.now().year - index).toString()
  );

  final List<Map<String, String>> countryOptions = [
    {'id': '1', 'name': 'العراق'},
    {'id': '2', 'name': 'اخرى'}
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

  void _onCountryChanged(String? selectedCountry) {
    if (selectedCountry != null) {
      setState(() {
        this.selectedCountry = selectedCountry;
        if (selectedCountry == '1') {
          widget.countryController.text = 'العراق';
        } else {
          widget.countryController.clear();
        }
      });
    }
  }

  Widget _buildBirthDateSection(double spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 4, bottom: spacing * 0.5),
          child: Text(
            'تاريخ الميلاد',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'اليوم',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Color(0xFFd6dedf),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                value: widget.selectedDay?.toString(),
                items: days.map((day) {
                  return DropdownMenuItem<String>(
                    value: day.toString(),
                    child: Text(
                      day.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: widget.onDayChanged,
              ),
            ),
            SizedBox(width: spacing * 0.5),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'الشهر',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Color(0xFFd6dedf),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                value: widget.selectedMonth,
                items: months.map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(
                      month,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: widget.onMonthChanged,
              ),
            ),
            SizedBox(width: spacing * 0.5),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'السنة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Color(0xFFd6dedf),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                value: widget.selectedYear,
                items: years.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(
                      year,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  widget.onYearChanged(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double screenWidth = Get.width;
    double spacing = screenHeight * 0.02;
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: spacing);

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        children: [
          CustomTextField(
            labelText: 'الاسم الأول',
            controller: widget.firstNameController,
          ),
          SizedBox(height: spacing),

          CustomTextField(
            labelText: 'الاسم الأوسط',
            controller: widget.middleNameController,
          ),
          SizedBox(height: spacing),

          CustomTextField(
            labelText: 'الاسم الأخير',
            controller: widget.lastNameController,
          ),
          SizedBox(height: spacing),

          DropdownButtonFormField<String>(
            hint: Text("اختر البلد من هنا"),
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
              labelText: 'البلد',
              labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xFFd6dedf),
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
          SizedBox(height: spacing),

          if (selectedCountry == '1') ...[
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
                  widget.governorateController.text = value ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'المحافظة',
                labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Color(0xFFd6dedf),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'المحلة',
              controller: widget.districtController,
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'الزقاق',
              controller: widget.alleyController,
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'الدار',
              controller: widget.houseController,
            ),
          ] else if (selectedCountry == '2')
            FutureBuilder<List<Map<String, dynamic>>>(
              future: CountryService.fetchCountries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('فشل في تحميل قائمة الدول');
                } else if (snapshot.hasData) {
                  return DropdownButtonFormField<String>(
                    value: widget.countryController.text.isNotEmpty ? widget.countryController.text : null,
                    items: snapshot.data!.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['name'],
                        child: Text(country['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.countryController.text = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'البلد',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Color(0xFFd6dedf),
                    ),
                  );
                }
                return Container();
              },
            ),

          SizedBox(height: spacing),
          _buildBirthDateSection(spacing),
          SizedBox(height: spacing),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'الجنس',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xFFd6dedf),
            ),
            items: genderOptions.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              widget.onGenderChanged(newValue == 'ذكر' ? 1 : 2);
            },
          ),
        ],
      ),
    );
  }
}