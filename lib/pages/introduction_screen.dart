import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;
  final String illustrationAsset;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
    required this.illustrationAsset,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showLanguages = false;

  final List<Map<String, String>> languages = [
    {'name': 'العربية', 'code': 'ar'},
    {'name': 'فارسی', 'code': 'fa'},
    {'name': 'كوردي', 'code': 'ur'},
    {'name': 'تركماني', 'code': 'id'},
    {'name': 'English', 'code': 'en'},
  ];

  final List<OnboardingContent> contents = [
    OnboardingContent(
      image: 'assets/images/logo.png',
      illustrationAsset: 'assets/images/logo.png',
      title: 'طب الحشود',
      description: 'تقدم ميزة الرعاية الصحية للزائرين في ذلك خدمات طبية متخصصة تهدف إلى تلبية احتياجات الزوار اثناء رحلتهم',
    ),
    OnboardingContent(
      image: 'assets/images/logo.png',
      illustrationAsset: 'assets/images/logo.png',
      title: 'ميزة الاستشارة الطبية',
      description: 'تتيح ميزة الاستشارة الطبية للزائرين التواصل مع الأطباء عن بعد للحصول على نصائح صحية و استشارات متخصصة في مختلف المجالات الطبية',
    ),
    OnboardingContent(
      image: 'assets/images/logo.png',
      illustrationAsset: 'assets/images/logo.png',
      title: 'المراكز الطبية و المستشفيات القريبة',
      description: 'التعرف على أقرب المراكز الصحية عبر خريطة تفاعلية مع معلومات تفصيلية حول الخدمات المقدمة وأرقام التواصل',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.04,
                      vertical: Get.height * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF26A69A),
                            borderRadius: BorderRadius.circular(8), // اجعل الحواف مدورة هنا
                          ),
                          child: TextButton(
                            onPressed: () => setState(() => _showLanguages = !_showLanguages),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // اجعل الحواف مدورة هنا
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'العربية',
                                  style: TextStyle(color: Colors.white, fontSize: Get.width * 0.04),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.language, color: Colors.white, size: Get.width * 0.05),
                              ],
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            // Skip logic
                          },
                          child: Text(
                            'تخطي',
                            style: TextStyle(
                              color: Color(0xFF26A69A),
                              fontSize: Get.width * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                          _showLanguages = false;
                        });
                      },
                      itemCount: contents.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                          child: Column(
                            children: [
                              SizedBox(height: Get.height * 0.02),
                              SizedBox(
                                height: Get.height * 0.05,
                                child: Image.asset(
                                  contents[i].image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Expanded(
                                flex: 3,
                                child: Image.asset(
                                  contents[i].illustrationAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.03),
                              Text(
                                contents[i].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Get.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF26A69A),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Text(
                                contents[i].description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  contents.length,
                                      (index) => buildDot(index),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.04),
                              SizedBox(
                                width: double.infinity,
                                height: Get.height * 0.07,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_currentPage == contents.length - 1) {
                                      // Navigate to home page
                                    } else {
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF26A69A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    _currentPage == contents.length - 1 ? 'ابدأ' : 'التالي',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.width * 0.05,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.03),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (_showLanguages)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showLanguages = false;
                    });
                  },

                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    child: Stack(
                      children: [
                        Positioned(
                          top: Get.height * 0.1,
                          right: Get.width * 0.04,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: languages.map((language) => Container(
                                width: Get.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Color(0xFF26A69A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                margin: EdgeInsets.all(4),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showLanguages = false;
                                        // Implement language change logic here
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        language['name']!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Get.width * 0.04,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: Get.width * 0.02,
      width: _currentPage == index ? Get.width * 0.06 : Get.width * 0.02,
      margin: EdgeInsets.only(right: Get.width * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index
            ? Color(0xFF26A69A)
            : Color(0xFF26A69A).withOpacity(0.2),
      ),
    );
  }
}
