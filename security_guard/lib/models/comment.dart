class Comment {
  final int id;
  final int? articleId; // Make articleId nullable
  final String content;
  final DateTime createdDate;
  final String author;

  Comment({
    required this.id,
    this.articleId, // Make articleId nullable
    required this.content,
    required this.createdDate,
    required this.author,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      articleId: json['articleId'], // Allow null values
      content: json['content'],
      createdDate: DateTime.parse(json['createdDate']),
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'author': author,
      'articleId': articleId, // Include articleId in the payload
    };
  }

  // Simplified toJson method for sending data to the API
  Map<String, dynamic> toJsonForApi() {
    return {
      'author': author,
      'content': content,
    };
  }
}