import 'package:capstone_proj/functions/generative_model.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    this.isAI = false,
  });

  final String sender;
  final String text;
  final bool isMe;
  final bool isAI;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
                fontSize: 12.0, color: isMe ? Colors.blueGrey : Colors.yellow),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: isMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isAI
                      ? [
                          const Color(0xff027DFD),
                          const Color(0xff4100E0),
                          const Color(0xff1CDAC5),
                          const Color(0xffF2DD22),
                          // Colors.redAccent,
                        ]
                      : isMe
                          ? [Colors.amber, Colors.amberAccent]
                          : [Colors.white, Colors.white70],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          fontSize: 15.0,
                          color: !isAI
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.white),
                    ),
                    //ANCHOR - Where the AI response
                    if (isAI)
                      FutureBuilder<String>(
                        future: geminiGenerate(text),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
