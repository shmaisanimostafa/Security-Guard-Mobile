import 'package:capstone_proj/components/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends ChangeNotifier {
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

  void addMessage(MessageBubble message) {
    messages.add(message);
    notifyListeners();
  }

  void addMessageAI(String question) {
    final message =
        MessageBubble(sender: 'me, AI', text: question, isMe: true, isAI: true);

    messages.add(message);
    notifyListeners();
  }
}
