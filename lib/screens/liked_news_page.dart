import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework1/screens/article_page.dart';
import 'package:homework1/utils/like_toggle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:homework1/utils/riverpod_providers.dart';

class LikedNewsPage extends ConsumerStatefulWidget {
  const LikedNewsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LikedNewsPageState();
}

class _LikedNewsPageState extends ConsumerState<LikedNewsPage> {
  final String _defaultImageUrl =
      'https://www.servicedriventransport.com/wp-content/uploads/2023/06/News.jpg';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = ref.watch(themeProvider);
    final String locale = ref.watch(localeProvider);
    final likedNews = ref.watch(likedNewsProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.fav),
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
                ref.read(themeProvider.notifier).state =
                    !ref.read(themeProvider);
              },
              icon: Icon(
                isLightTheme ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ]),
      body: likedNews.isEmpty
          ? const Center(child: Text('No liked news.'))
          : ListView.builder(
              itemCount: likedNews.length,
              itemBuilder: (context, index) {
                final news = likedNews[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        news.urlToImage.isNotEmpty
                            ? news.urlToImage
                            : _defaultImageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(news.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        setState(() {
                          toggleLikeStatus(
                              ref.read(likedNewsProvider.notifier).state, news);
                        });
                      },
                      color: news.isLiked ? Colors.red : null,
                    ),
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
                  ),
                );
              },
            ),
    );
  }
}
