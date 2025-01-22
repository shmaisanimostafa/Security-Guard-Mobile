import 'package:capstone_proj/components/message_bubble.dart';

import 'package:capstone_proj/models/message.dart';
import 'package:flutter/material.dart';

class Messages extends ChangeNotifier {
  List<Message> data = [];

  List<MessageBubble> messages = [
    const MessageBubble(
      sender: 'me',
      text: 'Hello',
      isMe: true,
      isAI: false,
    ),
    const MessageBubble(
      sender: 'you',
      text: 'Hi',
      isMe: false,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'me',

      isAI: false,
      text: 'How are you?',
      isMe: true,
    ),
    const MessageBubble(
      sender: 'you',
      text: 'I am fine, thank you.',
      isMe: false,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'me',
      text: 'Good to hear that.',
      isMe: true,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'you',
      text: 'How about you?',
      isMe: false,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'me',
      text: 'I am doing great.',
      isMe: true,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'you',
      text: 'That is good to hear.',
      isMe: false,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'me',
      text: 'I have to go now.',
      isMe: true,
            isAI: false,

    ),
    const MessageBubble(
      sender: 'you',
      text: 'Okay, see you later.',
      isMe: false,
            isAI: false,

    ),
  ];

  void addMessage(MessageBubble message) {
    messages.add(message);
    notifyListeners();
  }

  void addMessageAI(String question) async {
    final message = MessageBubble(
      sender: 'me, AI',
      text: question,
      isMe: true,
      isAI: true,
    );

    messages.add(message);
    notifyListeners();
  }
}
