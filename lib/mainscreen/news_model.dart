import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(
      'https://medicalpoint-api.tatwer.tech/api/News/GetAllNews?PageNumber=1&PageSize=11',
    ));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return (parsed['items'] as List)
          .map<Article>((json) => Article.fromJson(json))
          .toList();
    } else {
      print('Failed to load news: ${response.statusCode}');
      throw Exception('Failed to load news');
    }
  }
}
class Article {
  final String titleNews;
  final String theContent;
  final String imageUrl;
  final String imageFullUrl;

  // Base URL for the API
  static const String baseUrl = 'https://medicalpoint-api.tatwer.tech';

  Article({
    required this.titleNews,
    required this.theContent,
    required this.imageUrl,
    required this.imageFullUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      titleNews: json['titleNews'] ?? '',
      theContent: json['theContent'] ?? '',
      imageFullUrl: json['imageFullUrl'] ?? '',
      imageUrl: json['imageUrl'] != null && json['imageUrl'].isNotEmpty
          ? '$baseUrl${json['imageUrl']}'
          : '', // Concatenate base URL with the image path
    );
  }
}