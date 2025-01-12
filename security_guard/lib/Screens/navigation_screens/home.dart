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
  //
  //SECTION Intiate Empty Article in Articles Data
  //
  late List<Article> data = [];

  //
  //SECTION Fetch Articles Data
  //
  void getData() async {
    data = await apiHandler.getArticles();
    setState(() {});
  }

  //
  //SECTION Fetch Articles Data in the beginning of the Widget
  //
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    int articleCount = data.length;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: ListView(
        children: [
          Row(
            children: [
              //SECTION - Return the number of articles fetched
              Text(
                '$articleCount Articles Fetched!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          //SECTION - Button to Refresh the Articles
          MaterialButton(
            onPressed: () {
              getData();
            },
            child: const Text('Refresh'),
          ),
          //SECTION - List of Articles
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    const Divider(),
                    ArticleCard(
                       id: data[index].id,
              title: data[index].title,
              author: "Mostafa Shmaisani",
              date: data[index].publishDate.toString(),
              // ignore: unnecessary_null_comparison
              imageUrl: data[index].imageURL != null && data[index].imageURL.isNotEmpty
                  ? data[index].imageURL
                  : 'images/Logo.png',
            ),
                  ],
                );
              },
              itemCount: data.length,
              shrinkWrap: true,
            ),
          )
        ],
      )),
    );
  }
}
