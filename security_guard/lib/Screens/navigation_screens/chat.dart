import 'package:capstone_proj/constants.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: null,
      //   actions: <Widget>[
      //     IconButton(
      //         icon: const Icon(Icons.close),
      //         onPressed: () {
      //           //Implement logout functionality
      //         }),
      //   ],
      //   title: const Text('⚡️Chat'),
      //    backgroundColor: Colors.lightBlueAccent,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.star),
        // backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MessageBubble(
                      sender: 'me',
                      text: 'Hello',
                      isMe: true,
                    ),
                    MessageBubble(
                      sender: 'you',
                      text: 'Hi',
                      isMe: false,
                    ),
                    MessageBubble(
                      sender: 'me',
                      text: 'How are you?',
                      isMe: true,
                    ),
                    MessageBubble(
                      sender: 'you',
                      text: 'I am fine, thank you.',
                      isMe: false,
                    ),
                    MessageBubble(
                      sender: 'me',
                      text: 'Good to hear that.',
                      isMe: true,
                    ),
                    MessageBubble(
                      sender: 'you',
                      text: 'How about you?',
                      isMe: false,
                    ),
                    MessageBubble(
                      sender: 'me',
                      text: 'I am doing great.',
                      isMe: true,
                    ),
                    MessageBubble(
                      sender: 'you',
                      text: 'That is good to hear.',
                      isMe: false,
                    ),
                    MessageBubble(
                      sender: 'me',
                      text: 'I have to go now.',
                      isMe: true,
                    ),
                    MessageBubble(
                      sender: 'you',
                      text: 'Okay, see you later.',
                      isMe: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      //Do something with the user input.
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    messageTextController.clear();
                    //Implement send functionality.
                  },
                  child: const Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
              style: TextStyle(
                  fontSize: 12.0, color: isMe ? Colors.white : Colors.yellow)),
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
            color: isMe ? Colors.yellow : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
