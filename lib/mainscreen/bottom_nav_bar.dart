import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../languages.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFf259e9f),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        items: [
          _buildNavItem('assets/icons/home.svg', 'home'.tr, 0),
          _buildNavItem('assets/icons/profile.svg','health_card'.tr, 1),
          _buildMapNavItem(),
          _buildNavItem('assets/icons/info.svg', 'support'.tr, 3),
          _buildNavItem('assets/icons/setting.svg', 'settings'.tr, 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String assetPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        color: selectedIndex == index ? Color(0xFf259e9f) : Colors.grey,
        width: Get.width * 0.06,
        height: Get.height * 0.03,
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildMapNavItem() {
    return BottomNavigationBarItem(
      icon: Container(
        height: Get.height * 0.07,
        width: Get.width * 0.12,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/map.svg',
            color: Color(0xFf259e9f),
            width: Get.width * 0.10,
            height: Get.height * 0.05,
          ),
        ),
      ),
      label: 'map'.tr,
    );
  }
}