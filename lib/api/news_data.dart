import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsData {
  static String apiUrl =
      'https://newsapi.org/v2/everything?q=apple&from=2024-03-09&to=2024-03-09&sortBy=popularity&apiKey=139bc32f7ef14f6eba78854d738dddfb';

  Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['articles'];
      return data
          .map((item) => NewsModel(
                author: item['author'] ?? '',
                title: item['title'] ?? '',
                description: item['description'] ?? '',
                url: item['url'] ?? '',
                urlToImage: item['urlToImage'] ?? '',
                content: item['content'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
