import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework1/models/news_model.dart';
import 'package:homework1/screens/liked_news_page.dart';
import 'package:homework1/utils/like_toggle.dart';
import '../utils/riverpod_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/url_launcher.dart';

class ArticlePage extends ConsumerStatefulWidget {
  final NewsModel article;

  const ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticlePageState();
}

class _ArticlePageState extends ConsumerState<ArticlePage> {
  final String _defaultImageUrl =
      'https://www.servicedriventransport.com/wp-content/uploads/2023/06/News.jpg';

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = ref.watch(themeProvider);
    final String locale = ref.watch(localeProvider);
    // final viewedArticle = ref.watch(viewedArticleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.article),
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
                MaterialPageRoute(builder: (context) => const LikedNewsPage()),
              ).then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.article.urlToImage != ''
                  ? widget.article.urlToImage
                  : _defaultImageUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  IconButton(
                    icon: Icon(widget.article.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      setState(() {
                        toggleLikeStatus(
                            ref.read(likedNewsProvider.notifier).state,
                            widget.article);
                      });
                    },
                    color: widget.article.isLiked ? Colors.red : null,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Author: ${widget.article.author}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.article.content,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () => launchURL(widget.article.url),
                    child: const Text(
                      'Read more',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
