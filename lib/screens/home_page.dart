import 'package:flutter/material.dart';
import 'package:homework1/api/news_data.dart';
import 'package:homework1/screens/article_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework1/utils/like_toggle.dart';
import '../utils/riverpod_providers.dart';
import 'liked_news_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
      ref.read(newsProvider.notifier).state = news;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = ref.watch(themeProvider);
    final String locale = ref.watch(localeProvider);
    final newsList = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(localeProvider.notifier).state =
                  locale == 'en' ? 'ru' : 'en';
            },
            icon: const Icon(Icons.language),
          ),
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).state = !ref.read(themeProvider);
            },
            icon: Icon(
              isLightTheme ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LikedNewsPage(),
                  )).then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: newsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (BuildContext context, int index) {
                final news = newsList[index];
                return GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   ref.read(viewedArticleProvider.notifier).state = news;
                    // });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticlePage(article: news),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
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
                          onPressed: () => {
                            setState(() {
                              toggleLikeStatus(
                                  ref.read(likedNewsProvider.notifier).state,
                                  newsList[index]);
                            })
                          },
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
