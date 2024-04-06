class Message {
  int id;
  final String text;
  final bool isAi;
  final String sender;
  // final DateTime timestamp;

  Message(
    this.id, {
    required this.isAi,
    required this.sender,
    required this.text,
    // required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['id'],
      // id: json['id'],
      text: json['text'],
      isAi: json['isAi'],
      sender: json['sender'],
      // timestamp: DateTime.parse(json['timestamp']
      // ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'text': text,
      'isAi': isAi,
      'sender': sender,
      // 'timestamp': timestamp.toIso8601String(),
    };
  }
}
