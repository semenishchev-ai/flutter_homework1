import 'package:homework1/models/news_model.dart';

void toggleLikeStatus(List<NewsModel> array, NewsModel article) {
    if (article.isLiked) {
      array.removeWhere((element) => element == article);
    } else {
      array.add(article);
    }
    // print('Did update, is empty: ${array.isEmpty}');
    article.isLiked = !article.isLiked;
}