class MongoMessage {
  String? id; // MongoDB's primary key
  String sender; // The sender of the message
  String receiver; // The receiver of the message
  String content; // The content of the message
  DateTime timestamp; // When the message was sent
  bool isRead; // To track if the message has been read
  bool isAi; // To track if the message is AI generated

  MongoMessage({
    this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.timestamp,
    required this.isRead,
    required this.isAi,
  });

  // Convert JSON to MongoMessage
  factory MongoMessage.fromJson(Map<String, dynamic> json) {
    return MongoMessage(
      id: json['_id'] as String?,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
      isAi: json['isAi'] as bool,
    );
  }

  // Convert MongoMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isAi': isAi,
    };
  }
}
