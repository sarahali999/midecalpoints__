import 'package:flutter/material.dart';

class Aboutapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFf259e9f), size: 35),
            SizedBox(width: 12),
            Text(
              'الشروط والخدمة',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFf259e9f),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحبًا بك في تطبيقنا الطبي الخدمي!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'يهدف تطبيقنا إلى توفير خدمات طبية متكاملة للزوار الوافدين من داخل وخارج العراق لزيارة مقام الإمام الحسين وأخيه العباس عليهما السلام.',
                style: TextStyle(fontSize: 18, height: 1.6),
              ),
              SizedBox(height: 20),
              Text(
                'نحن هنا لتقديم الرعاية الصحية والمساعدة الطبية في مختلف المواقف الطارئة أثناء زيارتك للموقع المقدس. يشمل التطبيق الخدمات التالية:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceItem('رعاية طبية طارئة داخل الموقع.'),
                  _buildServiceItem('استشارات طبية مع أطباء مختصين.'),
                  _buildServiceItem('توفير أدوية ومستلزمات طبية أساسية.'),
                  _buildServiceItem('خدمات الإسعاف والنقل الطبي.'),
                  _buildServiceItem('دعم نفسي للزوار.'),
                  _buildServiceItem('إرشادات طبية وقائية.'),
                  _buildServiceItem('أماكن طبية مجهزة داخل الحرم الشريف.'),
                ],
              ),
              SizedBox(height: 25),
              Text(
                'كيفية استخدام التطبيق:',
                style: TextStyle(
                  fontSize: 20, // زيادة حجم الخط
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepItem('يمكنك طلب المساعدة الطبية في أي وقت عبر التطبيق.'),
                  _buildStepItem('يمكنك العثور على أقرب نقطة طبية عبر الخريطة.'),
                  _buildStepItem('في حال الطوارئ، يتم التواصل مع فريق الإسعاف فورًا.'),
                ],
              ),
              SizedBox(height: 25),
              Text(
                'نحن نولي أهمية كبيرة لصحة الزوار، ونسعى لضمان راحتهم وأمنهم أثناء زيارتهم.',
                style: TextStyle(
                  fontSize: 18, // زيادة حجم النص
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFf259e9f),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'موافق',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check, color: Color(0xFf259e9f), size: 22),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }

  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.arrow_right, color: Color(0xFf259e9f), size: 22),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}