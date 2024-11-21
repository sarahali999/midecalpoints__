import 'package:flutter/material.dart';

class MedicationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFF259E9F),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        centerTitle: true,
        title: Text('الأدوية المصروفة لي',
        style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Text('الأدوية المصروفة لي'),
      ),
    );
  }
}
