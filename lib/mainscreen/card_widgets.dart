import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SmallCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color iconColor;

  SmallCard({
    required this.title,
    required this.iconPath,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width; // Get the screen width
    double height = Get.height; // Get the screen height

    // Adjust card size based on screen size
    double cardWidth = width * 0.25;
    double cardHeight = height * 0.15;

    return Container(
      width: cardWidth, // Responsive width
      height: cardHeight, // Responsive height
      decoration: BoxDecoration(
        color: Colors.white,
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
          SvgPicture.asset(
            iconPath,
            height: 32,
            color: iconColor,
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.04, // Adjust text size based on screen width
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
  final Color bgColor;
  final Color iconColor;

  LargeCard({
    required this.content,
    required this.title,
    required this.iconPath,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width; // Get the screen width
    double height = Get.height; // Get the screen height

    // Adjust card size based on screen size
    double cardWidth = width * 0.9;
    double cardHeight = height * 0.2;

    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: bgColor,
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
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: 40,
                color: iconColor,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.05, // Adjust text size based on screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            content,
            style: TextStyle(
              fontSize: width * 0.04, // Adjust text size based on screen width
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class CardBase extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color iconColor;
  final Widget? child;
  final double height;
  final Color bgColor;
  final bool isLargeCard;

  const CardBase({
    required this.title,
    required this.iconPath,
    required this.iconColor,
    this.child,
    this.height = 100,
    this.bgColor = Colors.white,
    this.isLargeCard = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.width; // Get the screen width
    double height = Get.height; // Get the screen height

    // Adjust card height based on screen size
    double cardHeight = height * 0.15;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: _buildBoxShadow(),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isLargeCard ? _buildLargeCard(context) : _buildSmallCard(),
    );
  }

  List<BoxShadow> _buildBoxShadow() {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        blurRadius: 6,
        spreadRadius: 2,
        offset: Offset(0, 2),
      ),
    ];
  }

  Widget _buildLargeCard(BuildContext context) {
    double width = Get.width; // Get the screen width
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 40,
              color: iconColor,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: width * 0.05, // Adjust text size based on screen width
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          (child != null) ? child!.toString() : '',
          style: TextStyle(fontSize: width * 0.04, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildSmallCard() {
    double width = Get.width; // Get the screen width
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 32,
          color: iconColor,
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
    );
  }
}
