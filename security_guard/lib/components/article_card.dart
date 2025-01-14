import 'package:capstone_proj/Screens/article_screen.dart';
import 'package:flutter/material.dart';
class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.title,
    required this.authorName,
    required this.isVerified,
    required this.date,
    required this.imageUrl,
    required this.id,
  });

  final int id;
  final String title;
  final String authorName;
  final bool isVerified;
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
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                softWrap: true,
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
                      Text(authorName),
                      if (isVerified)
                        const SizedBox(width: 5),
                      if (isVerified)
                        Icon(
                          Icons.verified,
                          size: 15,
                          color: Colors.blue.shade700,
                        ),
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
                        MaterialPageRoute(
                          builder: (context) {
                            return ArticleScreen(id: id);
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
