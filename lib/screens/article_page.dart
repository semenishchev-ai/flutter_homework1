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

class _ArticlePageState extends ConsumerState<ArticlePage>
    with SingleTickerProviderStateMixin {
  final String _defaultImageUrl =
      'https://www.servicedriventransport.com/wp-content/uploads/2023/06/News.jpg';

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: SingleChildScrollView(
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
                          GestureDetector(
                            onTap: () => {
                              setState(() {
                                toggleLikeStatus(
                                    ref.read(likedNewsProvider.notifier).state,
                                    widget.article);
                              })
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.all(widget.article.isLiked ? 8.0 : 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.article.isLiked ? Colors.red : null,
                              ),
                              child: Icon(
                                widget.article.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.article.isLiked ? Colors.white : null,
                              ),
                            ),
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
          }),
    );
  }
}
