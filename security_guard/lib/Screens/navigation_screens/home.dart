import 'package:capstone_proj/components/article_card.dart';
import 'package:capstone_proj/components/skeleton_article_card.dart';
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
  bool isLoading = true; // Add a loading state

  void getData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    data = await apiHandler.getArticles();
    setState(() {
      isLoading = false; // Stop loading after data is fetched
    });
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
                const SizedBox(height: 10),
                // Refresh Button with Loading State
                Opacity(
                  opacity: isLoading ? 0.5 : 1, // Reduce opacity when disabled
                  child: MaterialButton(
                    onPressed: isLoading ? null : getData, // Disable when loading
                    color: Colors.blue, // Button color
                    child: isLoading
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16, // Smaller width
                                height: 16, // Smaller height
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, // Thinner stroke
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Refreshing...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : const Text(
                            'Refresh',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                // Show linear progress indicator when loading
                if (isLoading)
                  const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow), // Yellow color
                  ),
                // Show skeleton loading or article list
                isLoading
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return const Column(
                            children: [
                              Divider(),
                              SkeletonArticleCard(), // Show skeleton card
                            ],
                          );
                        },
                        itemCount: 5, // Show 5 placeholder cards
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                                imageUrl: data[index].imageURL.isNotEmpty
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