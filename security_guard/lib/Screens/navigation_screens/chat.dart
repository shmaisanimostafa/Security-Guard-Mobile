import 'package:capstone_proj/components/message_bubble.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/screens/ai_chat_screen.dart';
import 'package:capstone_proj/screens/speech_to_text.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    List<MessageBubble> messages = [
      const MessageBubble(
        sender: 'me',
        text: 'Hello',
        isMe: true,
      ),
      const MessageBubble(
        sender: 'you',
        text: 'Hi',
        isMe: false,
      ),
      const MessageBubble(
        sender: 'me',
        text: 'How are you?',
        isMe: true,
      ),
      const MessageBubble(
        sender: 'you',
        text: 'I am fine, thank you.',
        isMe: false,
      ),
      const MessageBubble(
        sender: 'me',
        text: 'Good to hear that.',
        isMe: true,
      ),
      const MessageBubble(
        sender: 'you',
        text: 'How about you?',
        isMe: false,
      ),
      const MessageBubble(
        sender: 'me',
        text: 'I am doing great.',
        isMe: true,
      ),
      const MessageBubble(
        sender: 'you',
        text: 'That is good to hear.',
        isMe: false,
      ),
      const MessageBubble(
        sender: 'me',
        text: 'I have to go now.',
        isMe: true,
      ),
      const MessageBubble(
        sender: 'you',
        text: 'Okay, see you later.',
        isMe: false,
      ),
    ];
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            //Open Chat with AI Screen, Generative AI
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const AskAIScreen(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.star),
            // backgroundColor: Colors.lightBlueAccent,
          ),
          const SizedBox(height: 40.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: messages,
                ),
              ],
            ),
          ),
          Container(
            decoration: kMessageContainerDecoration,
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      //
                      // Edit the Message Text
                      //
                      messageText = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Clear the text field
                    messageTextController.clear();
                    setState(() {
                      messages.add(MessageBubble(
                        sender: 'me',
                        text: messageText,
                        isMe: true,
                      ));
                    });
                  },
                  child: const Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SpeechScreen();
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.mic),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
