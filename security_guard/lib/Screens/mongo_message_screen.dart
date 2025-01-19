import 'package:flutter/material.dart';
import 'package:capstone_proj/services/signalr_service.dart';
import 'package:capstone_proj/components/message_bubble.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/Screens/ai_chat_screen.dart';
import 'package:capstone_proj/Screens/speech_to_text.dart';

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
  bool _isSending = false;

  // Scroll controller for ListView
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSignalR().then((_) {
      _fetchMessages();
    });

    // Mark messages as read when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var message in messages) {
        if (message["receiver"] == "User1" && !message["isRead"]) {
          signalRService.markMessageAsRead(message["id"]);
        }
      }
    });
  }

  Future<void> _initializeSignalR() async {
    try {
      await signalRService.connect();
      signalRService.onMessageReceived = (message) {
        print("Message received: $message");
        setState(() {
          messages.add(message); // Add new message to the end of the list
        });
        _scrollToBottom();
      };

      signalRService.onMessageDeleted = (messageId) {
        print("Message deleted: $messageId");
        setState(() {
          var index = messages.indexWhere((msg) => msg["id"] == messageId);
          if (index != -1) {
            // Update the message content to "Message Deleted!"
            messages[index]["content"] = "Message Deleted!";
            messages[index]["isDeleted"] = true; // Add a flag to indicate the message is deleted
          }
        });
      };

      signalRService.onMessageEdited = (message) {
        print("Message edited: $message");
        setState(() {
          var index = messages.indexWhere((msg) => msg["id"] == message["id"]);
          if (index != -1) {
            messages[index] = message; // Update the edited message
          }
        });
      };

      signalRService.onMessageReacted = (reaction) {
        print("Message reacted: $reaction");
        setState(() {
          var index = messages.indexWhere((msg) => msg["id"] == reaction["messageId"]);
          if (index != -1) {
            messages[index]["reactions"] = reaction["reactions"]; // Update reactions
          }
        });
      };

    } catch (e) {
      print("Error initializing SignalR: $e");
    }
  }

  Future<void> _fetchMessages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final fetchedMessages = await signalRService.getMessageHistory();
      setState(() {
        messages = List<Map<String, dynamic>>.from(fetchedMessages.reversed);
      });
      _scrollToBottom();
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final newMessage = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "sender": "User1",
      "receiver": "Group1",
      "content": text,
      "timestamp": DateTime.now().toIso8601String(),
      "isAi": false,
      "isRead": false,
      "isEdited": false,
      "reactions": {},
    };

    setState(() {
      messages.add(newMessage);
    });

    try {
      await signalRService.sendMessage("User1", "Group1", text, false);
      setState(() {
        messageTextController.clear(); // Clear the text field
      });
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _editMessage(String messageId, String newContent) async {
    try {
      await signalRService.editMessage(messageId, newContent);
    } catch (e) {
      print("Error editing message: $e");
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      await signalRService.deleteMessage(messageId);
      print("Message deleted locally: $messageId");
    } catch (e) {
      print("Error deleting message: $e");
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete message: $e"),
        ),
      );
    }
  }

  void _showEditDialog(String messageId, String currentText) {
    final textController = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Edit your message...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newText = textController.text.trim();
                if (newText.isNotEmpty) {
                  _editMessage(messageId, newText);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

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
                    reverse: false,
                    controller: _scrollController,
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
                              isMe: message["sender"] == "User1",
                              isRead: message["isRead"],
                              isEdited: message["isEdited"] ?? false,
                              reactions: Map<String, String>.from(message["reactions"] ?? {}),
                              onEdit: (currentText) {
                                _showEditDialog(message["id"], currentText);
                              },
                              onDelete: () {
                                _deleteMessage(message["id"]);
                              },
                            ),
                          if (_isSending)
                            const Center(
                              child: CircularProgressIndicator(),
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