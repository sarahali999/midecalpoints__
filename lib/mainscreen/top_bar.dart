import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../languages.dart';
import '../loading_screen.dart';
import 'notifications_page.dart';
import 'profile.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onSearch;

  const TopBar({Key? key, this.onSearch}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(140.0);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xfff6f6f6),
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
                  color: const Color(0xFF259E9F),
                  width: Get.width * 0.07,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        onLoaded: () {
                          Get.off(() => Publicnotices());
                        },
                      ),
                    ),
                  );
                },
              ),
              // Center - App icon
              Image.asset(
                'assets/images/logo.png',
                width: Get.width * 0.12,
                color: const Color(0xFF259E9F),
              ),
              // Right side - Profile icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                        onLoaded: () {
                          Get.off(() => UserProfile());
                        },
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Get.width * 0.06,
                  child: SvgPicture.asset(
                    'assets/icons/profiles.svg',
                    color: const Color(0xFF259E9F),
                    width: Get.width * 0.07,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: buildSearchField(),
          ),
        ),
      ),
    );
  }
  Widget buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'search_hint'.tr,
        prefixIcon: Padding(
          padding: EdgeInsets.all(Get.width * 0.015),
          child: Icon(
            Icons.search,
            color: const Color(0xFF259E9F),
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
      onSubmitted: (value) {
        if (widget.onSearch != null) {
          widget.onSearch!(value);
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
