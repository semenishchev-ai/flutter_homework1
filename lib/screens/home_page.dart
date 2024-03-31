import 'package:flutter/material.dart';
import 'package:homework1/api/news_data.dart';
import 'package:homework1/models/news_model.dart';
import 'package:homework1/screens/article_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/notifiers.dart';
import 'liked_news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<NewsModel> _newsList = [];
  final String _defaultImageUrl =
      'https://www.servicedriventransport.com/wp-content/uploads/2023/06/News.jpg';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final news = await NewsData().fetchNews();
    setState(() {
      _newsList = news;
    });
  }

  void _toggleLikeStatus(NewsModel article) {
    setState(() {
      article.isLiked = !article.isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              localeNotifier.value = (localeNotifier.value.languageCode == 'en'
                  ? const Locale('ru')
                  : const Locale('en'));
            },
            icon: const Icon(Icons.language),
          ),
          IconButton(
            onPressed: () {
              themeNotifier.value = !themeNotifier.value;
            },
            icon: ValueListenableBuilder<bool>(
              valueListenable: themeNotifier,
              builder: (context, isLightTheme, _) {
                return Icon(
                  isLightTheme ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LikedNewsPage(
                      likedNews:
                          _newsList.where((news) => news.isLiked).toList()),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: _newsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (BuildContext context, int index) {
                final news = _newsList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticlePage(article: news),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            news.urlToImage.isNotEmpty
                                ? news.urlToImage
                                : _defaultImageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          news.description,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _toggleLikeStatus(_newsList[index]),
                          icon: Icon(news.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border),
                          color: news.isLiked ? Colors.red : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
