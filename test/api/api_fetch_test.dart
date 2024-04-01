import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:homework1/api/news_data.dart';
import 'package:homework1/models/news_model.dart';

void main() {
  group('NewsData', () {
    test('Returns a list of NewsModels', () async {
      final newsData = NewsData();

      final List<NewsModel> result = await newsData.fetchNews();

      expect(result.isNotEmpty, true);
      expect(result[0], isA<NewsModel>());
    });
  });
}
