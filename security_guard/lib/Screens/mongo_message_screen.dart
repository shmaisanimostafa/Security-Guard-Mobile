import 'package:flutter/material.dart';
import 'package:capstone_proj/services/signalr_service.dart';
import 'package:capstone_proj/components/message_bubble.dart'; // Import the MessageBubble widget
import 'package:capstone_proj/constants.dart'; // Import your constants
import 'package:capstone_proj/Screens/ai_chat_screen.dart'; // Import AI chat screen
import 'package:capstone_proj/Screens/speech_to_text.dart'; // Import speech-to-text screen

class MongoChatScreen extends StatefulWidget {
  const MongoChatScreen({super.key});

  @override
  State<MongoChatScreen> createState() => _MongoChatScreenState();
}

class _MongoChatScreenState extends State<MongoChatScreen> {
  final TextEditingController messageTextController = TextEditingController();
  final SignalRService signalRService = SignalRService();

  List<Map<String, dynamic>> messages = [];
  bool _isLoading = true;
  bool _isSending = false; // Track if a message is being sent

  // Scroll controller for ListView
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSignalR().then((_) {
      _fetchMessages();
    });
  }

  Future<void> _initializeSignalR() async {
    try {
      await signalRService.connect();
      signalRService.onMessageReceived = (message) {
        setState(() {
          messages.add(message); // Add new message to the end of the list
        });
        // Scroll to the bottom when a new message is received
        _scrollToBottom();
      };
    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  Future<void> _fetchMessages() async {
    try {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final fetchedMessages = await signalRService.getMessageHistory();
      setState(() {
        messages = List<Map<String, dynamic>>.from(fetchedMessages.reversed); // Reverse the fetched messages
      });
      // Scroll to the bottom after fetching messages
      _scrollToBottom();
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isSending = true; // Show sending indicator
    });

    final newMessage = {
      "sender": "User1", // Replace with the actual sender
      "receiver": "Group1", // Replace with the actual receiver
      "content": text,
      "timestamp": DateTime.now().toIso8601String(),
      "isAi": false,
    };

    setState(() {
      messages.add(newMessage); // Add the message to the end of the list
    });

    try {
      await signalRService.sendMessage("User1", "Group1", text, false);
      messageTextController.clear();
      // Scroll to the bottom after sending a message
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      setState(() {
        _isSending = false; // Hide sending indicator
      });
    }
  }

  // Scroll to the bottom of the ListView
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    signalRService.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            // Open Chat with AI Screen
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
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    reverse: false, // Set reverse to false
                    controller: _scrollController, // Attach the scroll controller
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var message in messages)
                            MessageBubble(
                              sender: message["sender"],
                              text: message["content"],
                              isMe: message["sender"] == "User1", // Replace with the actual sender
                            ),
                          if (_isSending)
                            const Center(
                              child: CircularProgressIndicator(), // Show sending indicator
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
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (messageTextController.text.isNotEmpty) {
                      _sendMessage(messageTextController.text);
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