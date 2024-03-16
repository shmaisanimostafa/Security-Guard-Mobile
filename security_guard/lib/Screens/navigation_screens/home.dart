import 'package:capstone_proj/components.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                ),
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const ArticleCard(
            title: "Cryptography and Network Security",
            author: "Mostafa Shmaisani",
            date: 'Feb 14 2023',
            imageUrl: 'images/logo.png',
          ),
          const Divider(),
          const ArticleCard(
            title: "Cryptography and Network Security",
            author: "Mostafa Shmaisani",
            date: 'Feb 14 2023',
            imageUrl: 'images/logo.png',
          ),
          const Divider(),
          const ArticleCard(
            title: "Cryptography and Network Security",
            author: "Mostafa Shmaisani",
            date: 'Feb 14 2023',
            imageUrl: 'images/logo.png',
          ),
          const Divider(),
          const ArticleCard(
            title: "Cryptography and Network Security",
            author: "Mostafa Shmaisani",
            date: 'Feb 14 2023',
            imageUrl: 'images/logo.png',
          ),
          const Divider(),
          const ArticleCard(
            title: "Cryptography and Network Security",
            author: "Mostafa Shmaisani",
            date: 'Feb 14 2023',
            imageUrl: 'images/logo.png',
          ),
          const Divider(),
        ],
      ),
    );
  }
}
