import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class MedicalSuppliesController extends GetxController {
  var supplies = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var jwtToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJwtTokenAndSupplies();
  }

  Future<void> fetchJwtTokenAndSupplies() async {
    await fetchJwtToken();
    if (jwtToken.value.isNotEmpty) {
      await fetchSupplies();
    } else {
      isLoading.value = false;
      errorMessage.value = "فشل في جلب رمز JWT";
    }
  }

  Future<void> fetchJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken.value = prefs.getString('token') ?? '';
  }

  Future<void> fetchSupplies() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientMedicalSuppliesDispense',
        ),
        headers: {
          'Authorization': 'Bearer ${jwtToken.value}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        supplies.value = data['value']['items'];
        isLoading.value = false;
      } else {
        throw Exception('فشل في تحميل المستلزمات الطبية');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}

class MedicalSuppliesWidget extends StatelessWidget {
  final MedicalSuppliesController controller = Get.put(MedicalSuppliesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المستلزمات الطبية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF259E9F),
                Color(0xFF1A7F80),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF259E9F)),
            ),
          );
        } else if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorView(controller.errorMessage.value);
        } else if (controller.supplies.isEmpty) {
          return _buildEmptyView();
        } else {
          return _buildSuppliesList();
        }
      }),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 60,
            color: Color(0xFF259E9F),
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد مستلزمات طبية مصروفة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF259E9F),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuppliesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.supplies.length,
      itemBuilder: (context, index) {
        final supply = controller.supplies[index];
        final medicalSupply = supply['medicalSupply'];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF5F5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF259E9F).withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: Color(0xFF259E9F),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          medicalSupply['name'] ?? 'غير محدد',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF259E9F),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF259E9F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'الكمية: ${supply['quantity']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.inventory, 'القطع في الحزمة', '${medicalSupply['piecesPerPacket']}'),
                      _buildInfoRow(Icons.inventory_2, 'عدد الحزم', '${medicalSupply['packetCount']}'),
                      _buildInfoRow(Icons.business, 'المورد', medicalSupply['supplier'] ?? 'غير محدد'),
                      _buildInfoRow(Icons.factory, 'المنتج', medicalSupply['producer'] ?? 'غير محدد'),
                      if (medicalSupply['expiryDate'] != null)
                        _buildInfoRow(
                          Icons.event,
                          'تاريخ انتهاء الصلاحية',
                          DateFormat('yyyy-MM-dd').format(DateTime.parse(medicalSupply['expiryDate'])),
                        ),
                      Divider(height: 24),
                      Text(
                        'معلومات المركز',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF259E9F),
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.local_hospital, 'اسم المركز', medicalSupply['center']['centerName'] ?? 'غير محدد'),
                      _buildInfoRow(Icons.location_on, 'العنوان', medicalSupply['center']['addressCenter'] ?? 'غير محدد'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}