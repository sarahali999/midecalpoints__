import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosisPage extends StatefulWidget {
  @override
  _DiagnosisPageState createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  List<dynamic> receipts = [];
  bool isLoading = true;
  String? errorMessage;
  String? jwtToken;

  @override
  void initState() {
    super.initState();
    fetchJwtToken();
  }

  Future<void> fetchJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    jwtToken = prefs.getString('token');
    if (jwtToken != null) {
      fetchPatientReceipts();
    } else {
      setState(() {
        errorMessage = 'لم يتم العثور على الرمز المميز. يرجى تسجيل الدخول.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchPatientReceipts() async {
    try {
      final response = await http.get(
        Uri.parse('https://medicalpoint-api.tatwer.tech/api/Mobile/GetPatientReceipts'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          receipts = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'حدث خطأ أثناء تحميل البيانات. الرجاء المحاولة لاحقاً.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ في الاتصال: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الحالة المرضية الكاملة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF259E9F), Color(0xFF1A7F80)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      )
          : receipts.isEmpty
          ? Center(
        child: Text(
          'لا يوجد تشخيص',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF259E9F),
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: receipts.length,
          itemBuilder: (context, index) {
            final receipt = receipts[index];
            return buildDiagnosisCard(receipt);
          },
        ),
      ),
    );
  }

  Widget buildDiagnosisCard(dynamic receipt) {
    return Card(
      color: Color(0xFFE8F5F3),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader('الحالة المرضية', Icons.medical_services),
            SizedBox(height: 10),
            buildInfoRow('التشخيص:', receipt['notes'] ?? 'غير متوفر'),
            buildInfoRow(
              'الطبيب المعالج:',
              '${receipt['medicalStaff']?['user']?['firstName'] ?? ''} ${receipt['medicalStaff']?['user']?['secondName'] ?? ''}',
            ),
            buildInfoRow('التخصص:', receipt['medicalStaff']?['specialization'] ?? 'غير متوفر'),
            buildInfoRow('المركز الطبي:', receipt['medicalStaff']?['center']?['centerName'] ?? 'غير متوفر'),
            buildInfoRow('العنوان:', receipt['medicalStaff']?['center']?['addressCenter'] ?? 'غير متوفر'),
            buildInfoRow('رقم الهاتف:', receipt['medicalStaff']?['center']?['phoneNumCenter'] ?? 'غير متوفر'),
            buildInfoRow('تاريخ التشخيص:', formatDate(receipt['createdAt'] ?? '')),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title, IconData icon) {
    return Row(
      
      children: [
        Icon(icon, color: Color(0xFF259E9F), size: 28),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF259E9F)),
        ),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'غير متوفر',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
  String formatDate(String dateString) {
    if (dateString.isEmpty) return 'غير متوفر';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return 'غير متوفر';
    }
  }
}
