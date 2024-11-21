import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'newsDetailPage.dart';
import 'news_model.dart';

class News extends StatelessWidget {

  News();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<Article>>(
      future: NewsService().fetchArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFf259e9f)),
            ),
          );
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(
            child: Text(
              'فشل في تحميل الأخبار',
              style: TextStyle(color: Colors.black),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'لا توجد أخبار متاحة',
              style: TextStyle(color: Colors.black),
            ),
          );
        }
        else {
          print('Loaded articles: ${snapshot.data}');
          return CarouselSlider(
            options: CarouselOptions(
              height: screenHeight * 0.3,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
            ),
            items: snapshot.data!.map((article) {
              return Builder(
                builder: (BuildContext context) {
                  // Pass selectedLanguage to AnimatedNewsCard
                  return AnimatedNewsCard(article: article);
                },
              );
            }
            ).toList(),
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
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                      child: Text(
                        widget.article.titleNews,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
