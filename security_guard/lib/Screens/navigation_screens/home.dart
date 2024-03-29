import 'package:capstone_proj/components/article_card.dart';
import 'package:capstone_proj/components/intro_buttons.dart';
import 'package:capstone_proj/components/intro_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          children: [
            Provider.of<bool>(context) == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' Mostafa Shmaisani !',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                : const Column(
                    children: [
                      IntroCard(),
                      SizedBox(height: 10),
                      IntroButtons(),
                    ],
                  ),
            const SizedBox(height: 10),
            const Divider(),
            const ArticleCard(
              title: "Cryptography and Network Security",
              author: "Mostafa Shmaisani",
              date: 'Feb 14 2023',
              imageUrl: 'images/ProfilePic.png',
            ),
            const Divider(),
            const ArticleCard(
              title: "Cryptography and Network Security",
              author: "Mostafa Shmaisani",
              date: 'Feb 14 2023',
              imageUrl: 'images/ProfilePic.png',
            ),
            const Divider(),
            const ArticleCard(
              title: "Cryptography and Network Security",
              author: "Mostafa Shmaisani",
              date: 'Feb 14 2023',
              imageUrl: 'images/ProfilePic.png',
            ),
            const Divider(),
            const ArticleCard(
              title: "Cryptography and Network Security",
              author: "Mostafa Shmaisani",
              date: 'Feb 14 2023',
              imageUrl: 'images/ProfilePic.png',
            ),
            const Divider(),
            const ArticleCard(
              title: "Cryptography and Network Security",
              author: "Mostafa Shmaisani",
              date: 'Feb 14 2023',
              imageUrl: 'images/ProfilePic.png',
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
