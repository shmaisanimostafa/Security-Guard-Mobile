import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/screens/article.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {super.key,
      required this.title,
      required this.author,
      required this.date,
      required this.imageUrl});

  final String title;
  final String author;
  final String date;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          imageUrl,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Container(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 5),
              Text(
                title,
                style: kArticleCardTitleStyle,
              ),
              Container(height: 5),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 10.0,
                    backgroundImage: AssetImage('images/ProfilePic.png'),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    author,
                  ),
                ],
              ),
              Container(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    maxLines: 2,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Article();
                          }),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}