// import 'dart:convert';
import 'article.dart';

class Comment {
  final int id;
  final int articleId;
  final String author;
  final String content;
  final DateTime createdDate;
  final Article? article;

  Comment({
    required this.id,
    required this.articleId,
    required this.author,
    required this.content,
    required this.createdDate,
    this.article,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      articleId: json['articleId'],
      author: json['author'],
      content: json['content'],
      createdDate: DateTime.parse(json['createdDate']),
      article: json['article'] != null ? Article.fromJson(json['article']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'articleId': articleId,
      'author': author,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'article': article?.toJson(),
    };
  }
}
