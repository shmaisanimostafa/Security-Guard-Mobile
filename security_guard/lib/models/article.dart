import 'package:capstone_proj/models/author.dart';
import 'package:capstone_proj/models/comment.dart';

class Article {
  final int id;
  final int rating;
  final int readCount;
  final int likeCount;
  final int disLikeCount;
  final String content;
  final String summary;
  final bool isFeatured;
  final String sourceURL;
  final String title;
  final String imageURL;
  final DateTime publishDate;
  final Author author;
  final List<Comment> comments;

  Article({
    required this.id,
    required this.rating,
    required this.readCount,
    required this.likeCount,
    required this.disLikeCount,
    required this.content,
    required this.summary,
    required this.isFeatured,
    required this.sourceURL,
    required this.title,
    required this.imageURL,
    required this.publishDate,
    required this.author,
    this.comments = const [], // Default value for comments
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      rating: json['rating'],
      readCount: json['readCount'],
      likeCount: json['likeCount'],
      disLikeCount: json['disLikeCount'],
      content: json['content'],
      summary: json['summary'],
      isFeatured: json['isFeatured'],
      sourceURL: json['sourceURL'],
      title: json['title'],
      imageURL: json['imageURL'],
      publishDate: DateTime.parse(json['publishDate']),
      author: Author.fromJson(json['author']),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [], // Handle null or missing comments
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'readCount': readCount,
      'likeCount': likeCount,
      'disLikeCount': disLikeCount,
      'content': content,
      'summary': summary,
      'isFeatured': isFeatured,
      'sourceURL': sourceURL,
      'title': title,
      'imageURL': imageURL,
      'publishDate': publishDate.toIso8601String(),
      'author': author.toJson(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}