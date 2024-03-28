import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/screens/article.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image.asset('images/Logo.png'),
            title: const Text(
              'Welcome to Security Guard!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Scan any threat and get the details!'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.teal),
                ),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Scan Now'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

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

//
//STUB - The Upload Box Widget
//

class UploadBox extends StatelessWidget {
  const UploadBox({
    super.key,
    required this.boxText,
    required this.backColor,
    required this.dotColor,
    required this.icon,
  });
  final String boxText;
  final Color backColor;
  final Color dotColor;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      dashPattern: const [10, 10],
      color: dotColor,
      strokeWidth: 2,
      child: Card(
        margin: const EdgeInsets.all(20),
        color: backColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 200.0,
          width: 200.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50.0, color: Colors.black),
                Text(boxText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
