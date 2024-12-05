import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../languages.dart';
import '../loading_screen.dart';
import '../login/verification.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen();
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardingContent {
  final String image, titleKey, descriptionKey, illustrationAsset;

  const OnboardingContent({
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
    required this.illustrationAsset,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showLanguages = false;
  String _selectedLanguage = 'العربية';

  static const _primaryColor = Color(0xFf259e9f);
  static const _languages = ['العربية', 'فارسی', 'كوردي', 'تركماني', 'English'];
  bool isRTL = true;

  static const _contents = [
    OnboardingContent(
      image: 'assets/images/logo.png',
      illustrationAsset: 'assets/images/page.png',
      titleKey: 'crowd_medicine',
      descriptionKey: 'crowd_medicine_desc',
    ),
    OnboardingContent(
      image: 'assets/images/logo.png',
      illustrationAsset: 'assets/images/page2.png',
      titleKey: 'medical_consultation',
      descriptionKey: 'medical_consultation_desc',
    ),
    OnboardingContent(
      image: 'assets/images/logo.png',
      illustrationAsset: 'assets/images/page3.png',
      titleKey: 'medical_centers',
      descriptionKey: 'medical_centers_desc',
    ),
  ];
  void _onLanguageSelected(String language) async {
    final prefs = await SharedPreferences.getInstance();

    String languageCode = 'ar';
    switch (language) {
      case 'العربية':
        languageCode = 'ar';
        break;
      case 'فارسی':
        languageCode = 'fa';
        break;
      case 'كوردي':
        languageCode = 'ku';
        break;
      case 'تركماني':
        languageCode = 'tk';
        break;
      case 'English':
        languageCode = 'en';
        break;
    }

    await prefs.setString('selectedLanguageCode', languageCode);
    await prefs.setString('selectedLanguage', language);

    setState(() {
      _selectedLanguage = language;
      _showLanguages = false;

      isRTL = Languages.isRTL(languageCode);
      Get.updateLocale(Locale(languageCode));
    });
  }
  void _toggleLanguages() => setState(() => _showLanguages = !_showLanguages);

  void _navigateToPhone() {
    Get.off(() => LoadingScreen(
      onLoaded: () => Get.off(() => const Login()),
    ));
  }
  void _handleMainButtonPress() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentPage == _contents.length - 1) {
      await prefs.setBool('onboardingCompleted', true);
      Get.off(() => LoadingScreen(
        onLoaded: () => Get.off(() => const Login()),
      ));
    } else {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage') ?? 'العربية';

    _onLanguageSelected(savedLanguage);
  }  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                left: 0,
                right: 0,
                bottom: Get.height * 0.3,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffecf2f3),
                        Color(0xFFecf2f3),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(0),
                      topRight: const Radius.circular(0),
                      bottomLeft: Radius.circular(Get.width * 0.3),
                      bottomRight: Radius.circular(Get.width * 10),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildPageView()
                  ),
                ],
              ),
              if (_showLanguages) _buildLanguageOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildLanguageButton(), _buildSkipButton()],
      ),
    );
  }

  Widget _buildLanguageButton() {
    return TextButton(
      onPressed: _toggleLanguages,
      style: TextButton.styleFrom(
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Text(
            'language'.tr,
            style: TextStyle(color: Colors.white, fontSize: Get.width * 0.04),
          ),
          const SizedBox(width: 4),
          Icon(Icons.language, color: Colors.white, size: Get.width * 0.05),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = language == _selectedLanguage;
    return Container(
      width: Get.width * 0.2,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : _primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onLanguageSelected(language),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              language,
              style: TextStyle(
                color: isSelected ? _primaryColor : Colors.white,
                fontSize: Get.width * 0.04,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _navigateToPhone,
      child: Text(
        'skip'.tr,
        style: TextStyle(color: _primaryColor, fontSize: Get.width * 0.04),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (page) => setState(() => _currentPage = page),
      itemCount: _contents.length,
      itemBuilder: (context, index) => _buildPage(index),
    );
  }

  Widget _buildPage(int index) {
    final content = _contents[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.02),
          _buildLogo(content.image),
          SizedBox(height: Get.height * 0.01),
          _buildTitle(content.titleKey),
          SizedBox(height: Get.height * 0.02),
          _buildIllustration(content.illustrationAsset),
          SizedBox(height: Get.height * 0.03),
          _buildDescription(content.descriptionKey),
          SizedBox(height: Get.height * 0.04),
          _buildPageIndicator(),
          SizedBox(height: Get.height * 0.04),
          _buildMainButton(),
          SizedBox(height: Get.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildLogo(String image) => SizedBox(
    height: Get.height * 0.05,
    child: Image.asset(image, color: _primaryColor),
  );

  Widget _buildIllustration(String asset) =>
      Expanded(child: Image.asset(asset, fit: BoxFit.contain));

  Widget _buildTitle(String titleKey) {
    return Text(
      titleKey.tr,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: Get.width * 0.06,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
      ),
    );
  }

  Widget _buildDescription(String descriptionKey) {
    return Text(
      descriptionKey.tr,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: Get.width * 0.04,
        color: Colors.grey,
        height: 1.5,
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_contents.length, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
      child: Container(
        height: Get.width * 0.02,
        width: _currentPage == index ? Get.width * 0.06 : Get.width * 0.02,
        margin: EdgeInsets.only(right: Get.width * 0.01),
        decoration: BoxDecoration(
          color: _currentPage == index ? _primaryColor : _primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.07,
      child: ElevatedButton(
        onPressed: _handleMainButtonPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          _currentPage == _contents.length - 1 ? 'start_now'.tr : 'next'.tr,
          style: TextStyle(fontSize: Get.width * 0.05, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLanguageOverlay() {
    return Positioned(
      top: Get.height * 0.1,
      left: isRTL ? Get.width * 0.700 : null,
      right: !isRTL ? Get.width * 0.700 : null,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(Get.width * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            children: _languages.map(_buildLanguageOption).toList(),
          ),
        ),
      ),
    );
  }
}
