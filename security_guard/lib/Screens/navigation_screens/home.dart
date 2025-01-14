import 'package:capstone_proj/components/article_card.dart';
import 'package:capstone_proj/functions/article_api_handler.dart';
import 'package:capstone_proj/models/article.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ArticleAPIHandler apiHandler = ArticleAPIHandler();
  late List<Article> data = [];

  void getData() async {
    data = await apiHandler.getArticles();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    int articleCount = data.length;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '$articleCount Articles Fetched!',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    getData();
                  },
                  child: const Text('Refresh'),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
                  shrinkWrap: true, // Allow the ListView to take up only the space it needs
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const Divider(),
                        ArticleCard(
                          id: data[index].id,
                          title: data[index].title,
                          authorName: data[index].author.name,
                          isVerified: data[index].author.isVerified,
                          date: data[index].publishDate.toString(),
                          imageUrl: data[index].imageURL != null && data[index].imageURL.isNotEmpty
                              ? data[index].imageURL
                              : 'images/Logo.png',
                        ),
                      ],
                    );
                  },
                  itemCount: data.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}