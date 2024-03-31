import 'package:flutter/material.dart';
import 'package:homework1/models/news_model.dart';
import 'package:homework1/screens/article_page.dart';

class LikedNewsPage extends StatelessWidget {
  final List<NewsModel> likedNews;
  final String _defaultImageUrl =
      'https://www.servicedriventransport.com/wp-content/uploads/2023/06/News.jpg';

  const LikedNewsPage({Key? key, required this.likedNews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked News'),
        centerTitle: true,
      ),
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
                      overflow: TextOverflow.ellipsis, // Add ellipsis
                    ),
                    trailing: StatefulBuilder(
                      builder: (context, setState) {
                        return IconButton(
                          icon: Icon(news.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            setState(() {
                              news.isLiked = !news.isLiked;
                            });
                          },
                          color: news.isLiked ? Colors.red : null,
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticlePage(article: news),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
