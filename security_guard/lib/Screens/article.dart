import 'package:flutter/material.dart';

class Article extends StatelessWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: ListView(
        children: [
          const Text(
            'Crypto Currency and the Future of Money',
            style: TextStyle(
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
                    Text(
                      'Mostafa Shmaisani',
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
          const Text(
            'For the past few years, the world has been witnessing a new form of currency that is not controlled by any government or financial institution. This new form of currency is called cryptocurrency. Cryptocurrency is a digital or virtual currency that uses cryptography for security and is difficult to counterfeit because of this security feature. Cryptocurrencies are decentralized networks based on blockchain technology—a distributed ledger enforced by a disparate network of computers. A defining feature of cryptocurrencies is that they are generally not issued by any central authority, rendering them theoretically immune to government interference or manipulation.',
          ),
          Image.asset(
            'images/ProfilePic.png',
            // height: 200,
            // fit: BoxFit.fill,
          ),
          const SizedBox(height: 15.0),
          const Text(
            'For the past few years, the world has been witnessing a new form of currency that is not controlled by any government or financial institution. This new form of currency is called cryptocurrency. Cryptocurrency is a digital or virtual currency that uses cryptography for security and is difficult to counterfeit because of this security feature. Cryptocurrencies are decentralized networks based on blockchain technology—a distributed ledger enforced by a disparate network of computers. A defining feature of cryptocurrencies is that they are generally not issued by any central authority, rendering them theoretically immune to government interference or manipulation.',
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
