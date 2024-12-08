import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import '../languages.dart';
import 'all_news_page.dart';
import 'news_detail_page.dart';
import 'news_model.dart';

class News extends StatefulWidget {
  News();
  @override
  _NewsState createState() => _NewsState();
}
class _NewsState extends State<News> {
  int _currentIndex = 0;
  late Future<List<Article>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = NewsService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Article>>(
      future: _futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFf259e9f)),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'loading_news'.tr, // Add this key to the Languages class
              style: TextStyle(color: Colors.black),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'no_news_available'.tr, // Add this key to the Languages class
              style: TextStyle(color: Colors.black),
            ),
          );
        }
        else {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight * 0.3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: screenHeight * 0.22,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.05,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: snapshot.data!.map((article) {
                    return Builder(
                      builder: (BuildContext context) {
                        return AnimatedNewsCard(article: article);
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Directionality(
                    textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
                        ? TextDirection.rtl
                        : TextDirection.ltr,                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => AllNewsPopup(articles: snapshot.data!),
                                  );
                                },
                                child: Text(
                                  'view_all'.tr, // Add this key to the Languages class
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: snapshot.data!.asMap().entries.map((entry) {
                              int index = entry.key;
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? Color(0xFF259E9F)
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class AnimatedNewsCard extends StatefulWidget {
  final Article article;

  AnimatedNewsCard({required this.article});

  @override
  _AnimatedNewsCardState createState() => _AnimatedNewsCardState();
}

class _AnimatedNewsCardState extends State<AnimatedNewsCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNewsDetail(BuildContext context) {
    _controller.forward().then((_) {
      _controller.reverse();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) => NewsDetailModal(
            article: widget.article,
            controller: scrollController,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: () => _showNewsDetail(context),
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.article.imageFullUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF259E9F),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.article.titleNews,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.040,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Image.asset(
                              'assets/images/logo.png',
                              width: screenWidth * 0.08,
                              height: screenWidth * 0.08,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
