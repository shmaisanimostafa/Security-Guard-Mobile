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
  rating: 0, // Default value for rating
  readCount: 0, // Default value for read count
  likeCount: 0, // Default value for like count
  disLikeCount: 0, // Default value for dislike count
  content: 'Getting the Content',
  summary: 'Getting the Summary',
  isFeatured: false, // Default value for featured status
  sourceURL: 'https://example.com', // Placeholder source URL
  title: 'Getting Title',
  imageURL: 'images/ProfilePic.png',
  publishDate: DateTime.now(), // Current date and time
  authorId: '12345', // Placeholder author ID
  // author: null, // No author data
  comments: [], // No comments
  articleTags: [], // No article tags
);


  void getData() async {
    data = await apiHandler.getArticle(widget.id);
    setState(() {});
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
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15.0,
                    backgroundImage: AssetImage('images/ProfilePic.png'),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Mostafa Shmaisani',
                          ),
                          SizedBox(width: 5.0),
                          Icon(Icons.verified, size: 15, color: Colors.blue),
                        ],
                      ),
                      Text(
                        'Feb 23 - 2023',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Text(data.content),
            const SizedBox(height: 15.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data.imageURL,
                // height: 200,
                // fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 15.0),
            Text(data.content),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
