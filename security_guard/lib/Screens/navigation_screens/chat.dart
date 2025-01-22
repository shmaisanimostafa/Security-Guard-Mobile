import 'package:capstone_proj/components/message_bubble.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/functions/message_api_handler.dart';
import 'package:capstone_proj/models/message.dart';
import 'package:capstone_proj/Screens/ai_chat_screen.dart';
import 'package:capstone_proj/Screens/speech_to_text.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  String messageText = '';

  //
  //SECTION Intiate Empty Article in Articles Data
  //
  late List<Message> data = [];

  MessageAPIHandler messageAPIHandler = MessageAPIHandler();

  Future<void> getData() async {
    data = await messageAPIHandler.getMessages();
    setState(() {});
  }

  void addMessage(Message message) {
    setState(() {
      messageAPIHandler.addMessage(message);
      
    });
  }

  //
  //SECTION Fetch Articles Data in the beginning of the Widget
  //
  @override
  void initState() {
    super.initState();
    getData();
  }

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
            child: const Icon(Icons.auto_awesome_rounded),
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
                  children: [
                    for (Message message in data)
                      MessageBubble(
                        sender: message.sender,
                        text: message.text,
                        isMe: message.sender == 'Mostafa' ? true : false,
                      ),
                  ],
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
                    if (messageText != '') {
                      messageAPIHandler.addMessage(
                        Message(0,
                            isAi: false, sender: 'Mostafa', text: messageText),
                      );
                    }
                    messageText = '';
                    setState(() {
                      getData();
                    });
                  },
                  child: const Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       // return const SpeechScreen();
                    //     },
                    //   ),
                    // );
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
