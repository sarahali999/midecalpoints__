import 'package:flutter/material.dart';
import 'package:midecalpoints/mainscreen/topbar.dart';
import 'home.dart';
import 'health_card_page.dart';
import 'map_page.dart';
import 'help_page.dart';
import 'settings_page.dart';
import 'bottom_nav_bar.dart';
import 'package:latlong2/latlong.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isRTL = true;

  final List<Widget> _pages = [
    HomePage(),
    HealthInfo(),
    MapPage(
      initialLocation: LatLng(0, 0),
      locationName: "Default Location",
    ),
    Quicksupportnumbers(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isHomePage = _selectedIndex == 0;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: isHomePage ? TopBar() : null,
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
