import 'package:capstone_proj/components/message_bubble.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/screens/ai_chat_screen.dart';
import 'package:capstone_proj/screens/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:capstone_proj/models/messages.dart';
import 'package:provider/provider.dart';

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
                  children: Provider.of<Messages>(context).messages,
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
                      messageText = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    messageTextController.clear();
                    setState(() {
                      Provider.of<Messages>(context, listen: false)
                          .addMessage(MessageBubble(
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
