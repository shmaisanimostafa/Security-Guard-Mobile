import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe,
      this.isAI = false});

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
                fontSize: 12.0, color: isMe ? Colors.black : Colors.yellow),
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
                  colors: isAI
                      ? [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.5)
                        ]
                      : isMe
                          ? [Colors.yellow, Colors.yellowAccent]
                          : [Colors.white, Colors.white70],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    isAI
                        ? const Text(
                            'This is a sample response generated by the AI from the backend server.')
                        : const SizedBox.shrink(),
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
