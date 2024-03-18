import 'package:capstone_proj/components.dart';
import 'package:capstone_proj/screens/registration_screens/log_in.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          children: [
            const IntroCard(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Scan File')),
                FilledButton(onPressed: () {}, child: const Text('Scan Link')),
                FilledButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LogInScreen();
                    }));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                  ),
                  child: const Text('Sign Up',
                      style: TextStyle(color: Colors.white)),
                ),
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
