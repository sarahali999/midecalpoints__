import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Searchable_country.dart';
import 'countries.dart';
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
  final String? selectedYear;
  final Function(int?) onGenderChanged;
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
    required this.selectedYear,
    required this.onGenderChanged,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final Map<String, int> genderOptions = {
    'غير معروف': 0,
    'male'.tr: 1,
    'female'.tr: 2,
  };
  String? _currentGenderKey;


  String? selectedCountry;
  String? selectedGovernorate;

  @override
  void initState() {
    super.initState();

    _currentGenderKey = widget.selectedGender == 0
        ? null
        : genderOptions.entries.firstWhere((entry) => entry.value == widget.selectedGender).key;
  }


  final List<Map<String, String>> countryOptions = [
    {'id': '1', 'name': 'العراق'},
    {'id': '2', 'name': 'other_country'.tr},
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
        widget.countryController.text = selectedCountry == '1' ? 'العراق' : '';
      });
    }
  }

  Widget _buildBirthYearSection(double spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 4, bottom: spacing * 0.5),
          child: Text(
            'birth_date'.tr,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.3,
                  maxChildSize: 0.8,
                  expand: false,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: List.generate(100, (index) => (DateTime.now().year - index).toString()).length,
                      itemBuilder: (context, index) {
                        String year = (DateTime.now().year - index).toString();
                        return ListTile(
                          title: Text(year, style: TextStyle(fontSize: 16)),
                          onTap: () {
                            widget.onYearChanged(year);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: TextEditingController(text: widget.selectedYear),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFd6dedf),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
              ),
            ),
          ),
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
            labelText: 'first_name'.tr,
            controller: widget.firstNameController,

          ),
          SizedBox(height: spacing),
          CustomTextField(
            labelText: 'middle_name'.tr,
            controller: widget.middleNameController,

          ),
          SizedBox(height: spacing),
          CustomTextField(
            labelText: 'last_name'.tr,
            controller: widget.lastNameController,

          ),
          SizedBox(height: spacing),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    minChildSize: 0.2,
                    maxChildSize: 0.4,
                    expand: false,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: countryOptions.length,
                          itemBuilder: (context, index) {
                            final item = countryOptions[index];
                            return ListTile(
                              title: Text(item['name']!, style: TextStyle(fontSize: 16)),
                              onTap: () {
                                _onCountryChanged(item['id']);
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
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(text: selectedCountry != null ? countryOptions.firstWhere((c) => c['id'] == selectedCountry)['name'] : ''),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'country'.tr,
                  filled: true,
                  fillColor: Color(0xFFd6dedf),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),
          if (selectedCountry == '1') ...[
            SizedBox(height: spacing),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      minChildSize: 0.3,
                      maxChildSize: 0.8,
                      expand: false,
                      builder: (BuildContext context, ScrollController scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: iraqGovernorates.length,
                            itemBuilder: (context, index) {
                              final item = iraqGovernorates[index];
                              return ListTile(
                                title: Text(item['name']!, style: TextStyle(fontSize: 16)),
                                onTap: () {
                                  setState(() {
                                    selectedGovernorate = item['name'];
                                    widget.governorateController.text = selectedGovernorate!;
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
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: selectedGovernorate),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'province'.tr,
                    filled: true,
                    fillColor: Color(0xFFd6dedf),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'district'.tr,
              controller: widget.districtController,
            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'alley'.tr,
              controller: widget.alleyController,

            ),
            SizedBox(height: spacing),
            CustomTextField(
              labelText: 'house'.tr,
              controller: widget.houseController,
            ),
          ] else if (selectedCountry == '2') ...[
            FutureBuilder<List<Map<String, dynamic>>>(
              future: CountryService.fetchCountries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('countries_error'.tr);
                } else if (snapshot.hasData) {
                  return SearchableDropdown(
                    items: snapshot.data!,
                    value: widget.countryController.text.isNotEmpty ? widget.countryController.text : null,
                    labelText: 'country'.tr,
                    onChanged: (value) {
                      setState(() {
                        widget.countryController.text = value ?? '';
                      });
                    },
                  );
                }
                return Container();
              },
            ),
          ],
          SizedBox(height: spacing),
          _buildBirthYearSection(spacing),
          SizedBox(height: spacing),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    minChildSize: 0.2,
                    maxChildSize: 0.4,
                    expand: false,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: genderOptions.entries.where((entry) => entry.value != 0).length,
                          itemBuilder: (context, index) {
                            final entry = genderOptions.entries.where((entry) => entry.value != 0).elementAt(index);
                            return ListTile(
                              title: Text(
                                entry.key,
                                style: TextStyle(fontSize: 16),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // تقليل الحشو
                              onTap: () {
                                setState(() {
                                  _currentGenderKey = entry.key;
                                  widget.onGenderChanged(entry.value);
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
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: TextEditingController(text: _currentGenderKey ?? ''),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'gender'.tr,
                  filled: true,
                  fillColor: Color(0xFFd6dedf),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),
        ],
      ),
    );
  }
}