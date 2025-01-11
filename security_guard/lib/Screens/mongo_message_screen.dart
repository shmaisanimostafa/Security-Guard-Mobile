import 'package:capstone_proj/components/message_bubble.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/functions/mongo_message_api_handler.dart';
import 'package:capstone_proj/models/mongo_message.dart';
import 'package:capstone_proj/Screens/ai_chat_screen.dart';
import 'package:capstone_proj/Screens/speech_to_text.dart';
import 'package:flutter/material.dart';

class MongoChatScreen extends StatefulWidget {
  const MongoChatScreen({super.key});

  @override
  State<MongoChatScreen> createState() => _MongoChatScreenState();
}

class _MongoChatScreenState extends State<MongoChatScreen> {
  final TextEditingController messageTextController = TextEditingController();
  final MongoMessageAPIHandler messageAPIHandler = MongoMessageAPIHandler();

  List<MongoMessage> messages = [];
  String messageText = '';

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
    _fetchMessages();
  }

  Future<void> _initializeSignalR() async {
    try {
      await messageAPIHandler.initializeSignalR((newMessage) {
        setState(() {
          messages.insert(0, newMessage); // Add to the top of the list
        });
      });
    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages = await messageAPIHandler.getMessages();
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  Future<void> _sendMessage(String text) async {
    final newMessage = MongoMessage(
      sender: 'Mostafa',
      receiver: 'receiver',
      content: text,
      isAi: false,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      messages.insert(0, newMessage); // Add to the top of the list immediately
    });

    try {
      final addedMessage = await messageAPIHandler.addMessage(newMessage);
      setState(() {
        messages[0] = addedMessage; // Update the message with the one from the server
      });

      messageTextController.clear();
      messageText = '';
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  void dispose() {
    messageAPIHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
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
                    for (MongoMessage message in messages)
                      MessageBubble(
                        sender: message.sender,
                        text: message.content,
                        isMe: message.sender == 'Mostafa',
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
                  onPressed: () async {
                    if (messageText.isNotEmpty) {
                      await _sendMessage(messageText);
                    }
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}