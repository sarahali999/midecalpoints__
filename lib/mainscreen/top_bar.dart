import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'notifications_page.dart';
import 'profile.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(140.0); // Includes AppBar + bottom search field

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Notification icon
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/notification.svg',
                color: Color(0xFF259E9F),
                width: Get.width * 0.07,
              ),
              onPressed: () {
                Get.to(() => Publicnotices());
              },
            ),

            // Center - App icon
            Image.asset(
              'assets/images/logo.png', // Replace with your app's logo path
              width: Get.width * 0.12,
              color: Color(0xFF259E9F),
            ),

            // Right side - Profile icon
            GestureDetector(
              onTap: () {
                Get.to(() => UserProfile());
              },
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                radius: Get.width * 0.06,
                child: SvgPicture.asset(
                  'assets/icons/profiles.svg',
                  color: Color(0xFF259E9F),
                  width: Get.width * 0.07,
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Height of the search field
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: _buildSearchField(),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'اكتب ما تريد ان تبحث عنه',
        prefixIcon: Padding(
          padding: EdgeInsets.all(Get.width * 0.015),
          child: Icon(
            Icons.search,
            color: Color(0xFF259E9F),
            size: Get.width * 0.06,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(
          vertical: Get.height * 0.015,
          horizontal: Get.width * 0.04,
        ),
      ),
      style: TextStyle(fontSize: Get.width * 0.045),
    );
  }
}