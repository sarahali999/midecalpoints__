import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'profile.dart';
import 'notificationsPage.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(150.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        preferredSize: Size.fromHeight(80.0),
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
