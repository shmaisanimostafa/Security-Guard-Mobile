import 'package:capstone_proj/functions/article_api_handler.dart';
import 'package:capstone_proj/models/article.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key, required this.id});

  final int id;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  ArticleAPIHandler apiHandler = ArticleAPIHandler();
  late Article data = Article(
    id: 1,
    rating: 0,
    readCount: 0,
    likeCount: 0,
    disLikeCount: 0,
    content: 'Loading content...',
    summary: 'Loading summary...',
    isFeatured: false,
    sourceURL: 'https://example.com',
    title: 'Loading title...',
    imageURL: 'images/Logo.png',
    publishDate: DateTime.now(),
    author: Author(
      name: 'Loading name...',
      isVerified: false,
      firstName: 'Loading first name...',
      lastName: 'Loading last name...',
      imageURL: 'images/ProfilePic.png',
    ),
    comments: [],
    articleTags: [],
  );

  void getData() async {
    try {
      final fetchedData = await apiHandler.getArticle(widget.id);
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(data.author.imageURL.isNotEmpty
                      ? data.author.imageURL
                      : 'images/ProfilePic.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data.author.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (data.author.isVerified) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Colors.blue,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${data.publishDate.day}-${data.publishDate.month}-${data.publishDate.year}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data.imageURL.isNotEmpty
                    ? data.imageURL
                    : 'images/Logo.png', // Fallback for missing image
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              data.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
