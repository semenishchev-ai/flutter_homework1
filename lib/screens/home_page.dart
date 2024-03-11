import 'package:flutter/material.dart';
import 'package:homework1/api/news_data.dart';
import 'package:homework1/models/news_model.dart';
import 'package:homework1/screens/article_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/notifiers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFetched = false;
  // int _count = 5;

  final ScrollController _scrollController = ScrollController();
  final String _defaultImageUrl =
      'https://www.servicedriventransport.com/wp-content/uploads/2023/06/News.jpg';
  List<NewsModel> newsList = [];

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_loadMoreData);
    fetchNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _loadMoreData() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     setState(() {
  //       _count += 5;
  //     });
  //   }
  // }

  Future<void> fetchNews() async {
    setState(() {
      _isFetched = false;
    });
    newsList = await NewsData().fetchNews();
    setState(() {
      _isFetched = true;
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
              localeNotifier.value = (localeNotifier.value.languageCode == 'en' ? const Locale('ru') : const Locale('en'));
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
        ],
      ),
      body: _isFetched
          ? ListView.builder(
              controller: _scrollController,
              itemCount: newsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticlePage(article: newsList[index]),
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
                              newsList[index].urlToImage != ''
                                  ? newsList[index].urlToImage
                                  : _defaultImageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                        const SizedBox(height: 10.0),
                        Text(
                          newsList[index].title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          newsList[index].description,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}