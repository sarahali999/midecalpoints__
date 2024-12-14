import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'Searchable_country.dart';
import 'countries.dart';
import 'custom.dart';

class EmergencyContactPage extends StatefulWidget {
  final TextEditingController emergencyContactNameController;
  final TextEditingController emergencyContactPhoneController;
  final TextEditingController emergencyContactCountryController;
  final TextEditingController emergencyContactProvinceController;
  final TextEditingController emergencyContactDistrictController;
  final TextEditingController emergencyContactAlleyController;
  final TextEditingController emergencyContactHouseController;
  final int emergencyContactRelationship;
  final Function(int) onRelationshipChanged;

  const EmergencyContactPage({
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // FocusNodes for all text fields
  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode countryFocusNode;
  late FocusNode provinceFocusNode;
  late FocusNode districtFocusNode;
  late FocusNode alleyFocusNode;
  late FocusNode houseFocusNode;
  late FocusNode relationshipFocusNode;

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
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    countryFocusNode = FocusNode();
    provinceFocusNode = FocusNode();
    districtFocusNode = FocusNode();
    alleyFocusNode = FocusNode();
    houseFocusNode = FocusNode();
    relationshipFocusNode = FocusNode();

    _currentRelationship = widget.emergencyContactRelationship == 0
        ? null
        : relationshipOptions.entries
        .firstWhere((entry) => entry.value == widget.emergencyContactRelationship)
        .key;
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    countryFocusNode.dispose();
    provinceFocusNode.dispose();
    districtFocusNode.dispose();
    alleyFocusNode.dispose();
    houseFocusNode.dispose();
    relationshipFocusNode.dispose();
    super.dispose();
  }

  void _showRelationshipPicker() {
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: relationshipOptions.length - 1,
                itemBuilder: (context, index) {
                  String option = relationshipOptions.keys
                      .where((key) => relationshipOptions[key] != 0)
                      .toList()[index];
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      setState(() {
                        _currentRelationship = option;
                        widget.onRelationshipChanged(relationshipOptions[option]!);
                      });
                      Navigator.pop(context); // Close the bottom sheet
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
          widget.emergencyContactCountryController.clear();
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
              focusNode: nameFocusNode,
              onSubmitted: (_) => FocusScope.of(context).requestFocus(phoneFocusNode),
            ),
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
                  focusNode: countryFocusNode,
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

            if (selectedCountry == '1')
              Column(
                children: [
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
                                          widget.emergencyContactProvinceController.text = selectedGovernorate!;
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
                        focusNode: provinceFocusNode,
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
                    labelText: 'emergencyContactPage.district'.tr,
                    controller: widget.emergencyContactDistrictController,
                    focusNode: districtFocusNode,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(alleyFocusNode),
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.alley'.tr,
                    controller: widget.emergencyContactAlleyController,
                    focusNode: alleyFocusNode,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(houseFocusNode),
                  ),
                  SizedBox(height: spacing),
                  CustomTextField(
                    labelText: 'emergencyContactPage.house'.tr,
                    controller: widget.emergencyContactHouseController,
                    focusNode: houseFocusNode,
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
                    return SearchableDropdown(
                      items: snapshot.data!,
                      value: widget.emergencyContactCountryController.text.isNotEmpty
                          ? widget.emergencyContactCountryController.text
                          : null,
                      labelText: 'emergencyContactPage.country'.tr,
                      onChanged: (value) {
                        setState(() {
                          widget.emergencyContactCountryController.text = value ?? '';
                        });
                      },
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
            GestureDetector(
              onTap: _showRelationshipPicker,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'emergencyContactPage.relationship'.tr,
                    hintText: _currentRelationship ?? 'اختر صلة القرابة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFd6dedf),
                  ),
                  controller: TextEditingController(text: _currentRelationship),
                  focusNode: relationshipFocusNode,
                ),
              ),
            ),
            SizedBox(height: spacing),
            Form(
              key: _formKey,
              child: IntlPhoneField(
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
                  widget.emergencyContactPhoneController.text = phone.completeNumber;
                  print(phone.completeNumber);
                },
                onCountryChanged: (country) {
                  _formKey.currentState?.reset();
                  print('Country changed to: ${country.code}');
                },
                focusNode: phoneFocusNode,
              ),
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }
}