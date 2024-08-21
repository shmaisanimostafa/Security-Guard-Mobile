import 'package:capstone_proj/Screens/article_screen.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {super.key,
      required this.title,
      required this.author,
      required this.date,
      required this.imageUrl,
      required this.id});

  final int id;
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
          child: Image.network(
            imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Container(width: 20),
        Expanded(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(height: 3.0),
              Text(
                softWrap: true,
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                      const SizedBox(width: 5),
                      Icon(
                        size: 15,
                        Icons.verified,
                        color: Colors.blue.shade700,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date, style: Theme.of(context).textTheme.bodySmall),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ArticleScreen(
                              id: id,
                            );
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
