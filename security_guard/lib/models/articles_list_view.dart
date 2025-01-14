import 'package:capstone_proj/components/article_card.dart';
import 'package:capstone_proj/components/intro_buttons.dart';
import 'package:capstone_proj/components/intro_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart'; // Assuming the Article model is in this path
import '../functions/article_api_handler.dart'; // Assuming API handler is in this path

class ArticlesListView extends StatefulWidget {
  const ArticlesListView({super.key});

  @override
  State<ArticlesListView> createState() => _ArticlesListViewState();
}

class _ArticlesListViewState extends State<ArticlesListView> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = ArticleAPIHandler().getArticles(); // Fetch the articles
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: articles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No articles available.'));
        }

        final articlesList = snapshot.data!;

        return ListView(
          children: [
            Provider.of<bool>(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' Mostafa Shmaisani!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                : const Column(
                    children: [
                      IntroCard(),
                      SizedBox(height: 10),
                      IntroButtons(),
                    ],
                  ),
            const SizedBox(height: 10),
            const Divider(),
            ...articlesList.map((article) {
              return Column(
                children: [
                  ArticleCard(
                    id: article.id,
                    title: article.title,
                    authorName: article.author.name,
                    isVerified: article.author.isVerified,
                    date:
                        '${article.publishDate.day}-${article.publishDate.month}-${article.publishDate.year}',
                    imageUrl: article.imageURL.isNotEmpty
                        ? article.imageURL
                        : 'images/ProfilePic.png',
                  ),
                  const Divider(),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
