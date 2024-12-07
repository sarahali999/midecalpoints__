import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../languages.dart';
import '../loading_screen.dart';
import 'map_page.dart';
import 'notifications_page.dart';
import 'profile.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading = false;

  Future<void> _searchAndNavigate(String query) async {
    if (query.isEmpty) return;
    setState(() => isLoading = true);

    final apiKey = '48b0594741134ba7a54846c836ba8935'; // Replace with your API key
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey'
    );

    try {
      final response = await http.get(url);
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results']?.isNotEmpty ?? false) {
          final lat = data['results'][0]['geometry']['lat'];
          final lng = data['results'][0]['geometry']['lng'];
          final searchLocation = LatLng(lat, lng);

          // Navigate to MapPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapPage(
                initialLocation: searchLocation,
                locationName: query,
              ),
            ),
          );
        } else {
          _showSnackBar('No matching locations found for: $query');
        }
      } else {
        _showSnackBar('Failed to connect to server: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error: $e");
      _showSnackBar('An error occurred during the search: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
              IconButton(
                icon: Image.asset(
                  'assets/icons/notifications.png',
                  color: const Color(0xFF259E9F),
                  width: Get.width * 0.08,
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
              Image.asset(
                'assets/images/logo.png',
                width: Get.width * 0.12,
                color: const Color(0xFF259E9F),
              ),
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
        if (value.isNotEmpty) {
          _searchAndNavigate(value);
        } else {
          _showSnackBar('Please enter a location to search.');
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