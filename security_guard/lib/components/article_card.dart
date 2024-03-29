import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/screens/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Container(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 5),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(height: 5),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 10.0,
                    backgroundImage: AssetImage('images/ProfilePic.png'),
                  ),
                  const SizedBox(width: 5),
                  Row(
                    children: [
                      Text(
                        author,
                      ),
                      SizedBox(width: 5),
                      Icon(
                        size: 15,
                        Icons.verified,
                        color: Colors.blue.shade700,
                      )
                    ],
                  ),
                ],
              ),
              Container(height: 5),
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
