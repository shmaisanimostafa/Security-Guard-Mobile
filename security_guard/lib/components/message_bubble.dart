import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    this.isAI = false,
    this.isRead = false,
    this.isEdited = false,
    this.reactions = const {},
    this.onEdit,
    this.onDelete,
    this.onReact,
  });

  final String sender;
  final String text;
  final bool isMe;
  final bool isAI;
  final bool isRead;
  final bool isEdited;
  final Map<String, String> reactions;
  final Function(String)? onEdit;
  final Function()? onDelete;
  final Function(String)? onReact;

  @override
  Widget build(BuildContext context) {
    final bool isDeleted = text == "Message Deleted!"; // Check if the message is deleted

    return GestureDetector(
      onLongPress: () {
        if (isMe && !isAI && !isDeleted) {
          _showMessageMenu(context); // Show the menu on long press
        }
      },
      onTap: () {
        if (!isMe && !isDeleted) {
          _showReactionPicker(context); // Show reaction picker on tap
        }
      },
      child: Padding(
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
                  // Change the background color if the message is deleted
                  color: isDeleted
                      ? Colors.red.withOpacity(0.3) // Red background for deleted messages
                      : null, // Default background (gradient)
                  gradient: isDeleted
                      ? null // Disable gradient for deleted messages
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isAI
                              ? [
                                  const Color(0xff027DFD),
                                  const Color(0xff4100E0),
                                  const Color(0xff1CDAC5),
                                  const Color(0xffF2DD22),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAI ? text.toUpperCase() : text,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: isDeleted
                              ? Colors.white // White text for deleted messages
                              : (!isAI
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : const Color.fromARGB(255, 255, 255, 255)),
                          fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal, // Italic for deleted messages
                        ),
                      ),
                      if (isEdited && !isDeleted)
                        Text(
                          '(Edited)',
                          style: TextStyle(
                            fontSize: 10,
                            color: isAI ? Colors.white : Colors.grey,
                          ),
                        ),
                      if (reactions.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: reactions.entries.map((entry) {
                            return Chip(
                              label: Text(entry.value),
                              backgroundColor: Colors.grey[200],
                              labelStyle: const TextStyle(fontSize: 12),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (isMe && !isAI && !isDeleted)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  Icons.done_all,
                  size: 12,
                  color: isRead ? Colors.blue : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Show a menu with edit and delete options
  void _showMessageMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context); // Close the menu
                if (onEdit != null) {
                  onEdit!(text); // Trigger the edit callback
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context); // Close the menu
                if (onDelete != null) {
                  onDelete!(); // Trigger the delete callback
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Show a reaction picker
  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            children: [
              IconButton(
                icon: Text('👍'),
                onPressed: () {
                  Navigator.pop(context);
                  if (onReact != null) {
                    onReact!('👍');
                  }
                },
              ),
              IconButton(
                icon: Text('❤️'),
                onPressed: () {
                  Navigator.pop(context);
                  if (onReact != null) {
                    onReact!('❤️');
                  }
                },
              ),
              IconButton(
                icon: Text('😄'),
                onPressed: () {
                  Navigator.pop(context);
                  if (onReact != null) {
                    onReact!('😄');
                  }
                },
              ),
              IconButton(
                icon: Text('😢'),
                onPressed: () {
                  Navigator.pop(context);
                  if (onReact != null) {
                    onReact!('😢');
                  }
                },
              ),
              IconButton(
                icon: Text('😡'),
                onPressed: () {
                  Navigator.pop(context);
                  if (onReact != null) {
                    onReact!('😡');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}