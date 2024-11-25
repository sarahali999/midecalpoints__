import 'package:flutter/material.dart';

class Aboutapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Color(0xFF259E9F),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'الشروط والخدمة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            'مرحبًا بك في تطبيقنا الطبي الخدمي!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
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
        'يهدف تطبيقنا إلى توفير خدمات طبية متكاملة للزوار الوافدين من داخل وخارج العراق لزيارة مقام الإمام الحسين وأخيه العباس عليهما السلام.',
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
            'خدماتنا الطبية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF259E9F),
            ),
          ),
          SizedBox(height: 16),
          _buildServiceItem('رعاية طبية طارئة داخل الموقع', Icons.local_hospital),
          _buildServiceItem('استشارات طبية مع أطباء مختصين', Icons.people),
          _buildServiceItem('توفير أدوية ومستلزمات طبية أساسية', Icons.medical_services),
          _buildServiceItem('خدمات الإسعاف والنقل الطبي', Icons.airport_shuttle),
          _buildServiceItem('دعم نفسي للزوار', Icons.psychology),
          _buildServiceItem('إرشادات طبية وقائية', Icons.health_and_safety),
          _buildServiceItem('أماكن طبية مجهزة داخل الحرم الشريف', Icons.place),
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
            'كيفية استخدام التطبيق',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF259E9F),
            ),
          ),
          SizedBox(height: 16),
          _buildStepItem(
            '١',
            'يمكنك طلب المساعدة الطبية في أي وقت عبر التطبيق',
          ),
          _buildStepItem(
            '٢',
            'يمكنك العثور على أقرب نقطة طبية عبر الخريطة',
          ),
          _buildStepItem(
            '٣',
            'في حال الطوارئ، يتم التواصل مع فريق الإسعاف فورًا',
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
        'نحن نولي أهمية كبيرة لصحة الزوار، ونسعى لضمان راحتهم وأمنهم أثناء زيارتهم.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
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
                fontWeight: FontWeight.bold,
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