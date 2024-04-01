import 'package:flutter_test/flutter_test.dart';
import 'package:homework1/models/news_model.dart';
import 'package:homework1/utils/like_toggle.dart';

void main() {
  group('toggleLikeStatus func', () {
    test('Toggling like', () {
      final List<NewsModel> array = [];

      final NewsModel article = NewsModel(
        author: 'Author 1',
        title: 'Article 1',
        description: 'Description 1',
        url: 'url1',
        urlToImage: 'image1',
        content: 'Content 1',
        isLiked: false,
      );

      toggleLikeStatus(array, article);

      expect(article.isLiked, equals(true));
      expect(array.length, equals(1));

      toggleLikeStatus(array, article);

      expect(article.isLiked, equals(false));
      expect(array.length, equals(0));
    });
  });
}
