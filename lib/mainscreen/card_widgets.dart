import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmallCard extends StatelessWidget {
  final String title;
  final String iconPath;

  SmallCard({
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;

    double cardWidth = width * 0.25;
    double cardHeight = height * 0.15;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Color(0xffdcf1f6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 32,
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class LargeCard extends StatelessWidget {
  final String content;
  final String title;
  final String iconPath;

  LargeCard({
    required this.content,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;

    double cardWidth = width * 0.9;
    double cardHeight = height * 0.16;

    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: Color(0xffdcf1f6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                iconPath,
                height: 40,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: width * 0.04,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
