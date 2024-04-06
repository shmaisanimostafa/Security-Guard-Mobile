import 'package:capstone_proj/components/article_card.dart';
import 'package:capstone_proj/functions/api_handler.dart';
import 'package:capstone_proj/models/article.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  APIHandler apiHandler = APIHandler();
  late List<Article> data = [
    Article(title: 'sample', body1: 'sample', body2: 'sample')
  ];

  void getData() async {
    data = await apiHandler.getArticles();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    int articleCount = data.length;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: ListView(
        children: [
          Row(
            children: [
              Text(
                '$articleCount Articles Fetched!',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          MaterialButton(
              onPressed: () {
                getData();
              },
              child: const Text('Refresh')),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  const Divider(),
                  ArticleCard(
                    title: data[index].title,
                    author: "Mostafa Shmaisani",
                    date: 'Sometime Feb 2023',
                    imageUrl: 'images/ProfilePic.png',
                  ),
                ],
              );
            },
            itemCount: data.length,
            shrinkWrap: true,
          )
        ],
      )
          // ListView(
          //   children: [
          //     Provider.of<bool>(context) == true
          //         ? Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               const Text(
          //                 'Welcome back',
          //                 style: TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               Text(
          //                 ' Mostafa Shmaisani !',
          //                 style: TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.bold,
          //                   color: Theme.of(context).primaryColor,
          //                 ),
          //               ),
          //             ],
          //           )
          //         : const Column(
          //             children: [
          //               IntroCard(),
          //               SizedBox(height: 10),
          //               IntroButtons(),
          //             ],
          //           ),
          //     const SizedBox(height: 10),
          //     const Divider(),
          //     const ArticleCard(
          //       title: "Cryptography and Network Security",
          //       author: "Mostafa Shmaisani",
          //       date: 'Feb 14 2023',
          //       imageUrl: 'images/ProfilePic.png',
          //     ),
          //     const Divider(),
          //     const ArticleCard(
          //       title: "Cryptography and Network Security",
          //       author: "Mostafa Shmaisani",
          //       date: 'Feb 14 2023',
          //       imageUrl: 'images/ProfilePic.png',
          //     ),
          //     const Divider(),
          //     const ArticleCard(
          //       title: "Cryptography and Network Security",
          //       author: "Mostafa Shmaisani",
          //       date: 'Feb 14 2023',
          //       imageUrl: 'images/ProfilePic.png',
          //     ),
          //     const Divider(),
          //     const ArticleCard(
          //       title: "Cryptography and Network Security",
          //       author: "Mostafa Shmaisani",
          //       date: 'Feb 14 2023',
          //       imageUrl: 'images/ProfilePic.png',
          //     ),
          //     const Divider(),
          //     const ArticleCard(
          //       title: "Cryptography and Network Security",
          //       author: "Mostafa Shmaisani",
          //       date: 'Feb 14 2023',
          //       imageUrl: 'images/ProfilePic.png',
          //     ),
          //     const Divider(),
          //   ],
          // ),
          ),
    );
  }
}
