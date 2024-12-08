import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Aboutapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xFF259E9F),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'about_app.title'.tr,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderSection(),
              _buildContentSection(),
              _buildServicesSection(),
              _buildHowToUseSection(),
              _buildFooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: Color(0xFF259E9F),
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'about_app.welcome_message'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF259E9F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'about_app.description'.tr,
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'about_app.services_title'.tr,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF259E9F),
            ),
          ),
          SizedBox(height: 16),
          _buildServiceItem('about_app.services.emergency_care'.tr, Icons.local_hospital),
          _buildServiceItem('about_app.services.medical_consultation'.tr, Icons.people),
          _buildServiceItem('about_app.services.basic_medical_supplies'.tr, Icons.medical_services),
          _buildServiceItem('about_app.services.ambulance'.tr, Icons.airport_shuttle),
          _buildServiceItem('about_app.services.psychological_support'.tr, Icons.psychology),
          _buildServiceItem('about_app.services.preventive_guidance'.tr, Icons.health_and_safety),
          _buildServiceItem('about_app.services.medical_facilities'.tr, Icons.place),
        ],
      ),
    );
  }

  Widget _buildHowToUseSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'about_app.how_to_use_title'.tr,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF259E9F),
            ),
          ),
          SizedBox(height: 16),
          _buildStepItem(
            '١',
            'about_app.steps.step1'.tr,
          ),
          _buildStepItem(
            '٢',
            'about_app.steps.step2'.tr,
          ),
          _buildStepItem(
            '٣',
            'about_app.steps.step3'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF259E9F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'about_app.footer_message'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF259E9F),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildServiceItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF259E9F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF259E9F), size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF259E9F),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}