import 'package:capstone_proj/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:capstone_proj/services/signalr_service.dart'; // Import the SignalRService
import 'package:capstone_proj/components/message_bubble.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/functions/mongo_message_api_handler.dart';
import 'package:capstone_proj/models/mongo_message.dart';
import 'package:capstone_proj/Screens/ai_chat_screen.dart';
import 'package:capstone_proj/Screens/speech_to_text.dart';

class MongoChatScreen extends StatefulWidget {
  const MongoChatScreen({super.key});

  @override
  State<MongoChatScreen> createState() => _MongoChatScreenState();
}

class _MongoChatScreenState extends State<MongoChatScreen> {
  final TextEditingController messageTextController = TextEditingController();
  final MongoMessageAPIHandler messageAPIHandler = MongoMessageAPIHandler();
  late SignalRService signalRService;
  late AuthProvider authProvider;

  List<MongoMessage> messages = [];
  String messageText = '';
  bool _isSending = false; // Track whether a message is being sent
  bool _isLoading = true; // Track whether messages are being loaded

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider(); // Initialize AuthProvider
    signalRService = SignalRService(authProvider); // Pass AuthProvider to SignalRService
    _initializeSignalR();
    _fetchMessages();
  }

  Future<void> _initializeSignalR() async {
    try {
      await signalRService.startConnection(onMessageReceived: (user, message) {
        setState(() {
          messages.insert(0, MongoMessage(
            sender: user,
            receiver: 'receiver',
            content: message,
            isAi: false,
            timestamp: DateTime.now(),
            isRead: false,
          ));
        });
      });
    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  Future<void> _fetchMessages() async {
    try {
      setState(() {
        _isLoading = true; // Show loading animation
      });

      final fetchedMessages = await messageAPIHandler.getMessages();
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading animation
      });
    }
  }

  Future<void> _sendMessage(String text) async {
  setState(() {
    _isSending = true; // Show sending animation
  });

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

    // Wait for the SignalR connection to be ready
    await signalRService.isConnectionReady;

    // Send the message via SignalR
    await signalRService.sendMessage('Mostafa', text);

    messageTextController.clear();
    messageText = '';
  } catch (e) {
    print("Error sending message: $e");
  } finally {
    setState(() {
      _isSending = false; // Hide sending animation
    });
  }
}


  @override
  void dispose() {
    signalRService.stopConnection();
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(), // Show loading animation
                  )
                : ListView(
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
                          if (_isSending)
                            const Center(
                              child: CircularProgressIndicator(), // Show sending animation
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
                    if (messageText.isNotEmpty && !_isSending) {
                      await _sendMessage(messageText);
                    }
                  },
                  child: _isSending
                      ? const CircularProgressIndicator() // Show sending animation
                      : const Text(
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