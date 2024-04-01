import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework1/models/news_model.dart';

final themeProvider = StateProvider((ref) => true);
final localeProvider = StateProvider((ref) => 'en');
final likedNewsProvider = StateProvider((ref) => <NewsModel>[]);
final newsProvider = StateProvider((ref) => <NewsModel>[]);
final viewedArticleProvider = StateProvider((ref) => NewsModel(
    author: '',
    title: '',
    description: '',
    url: '',
    urlToImage: '',
    content: '',
    isLiked: false));
