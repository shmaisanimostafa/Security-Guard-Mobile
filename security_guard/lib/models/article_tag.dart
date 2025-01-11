// import 'dart:convert';
import 'article.dart';
import 'tag.dart';

class ArticleTag {
  final int articleId;
  final Article? article;
  final int tagId;
  final Tag? tag;

  ArticleTag({
    required this.articleId,
    this.article,
    required this.tagId,
    this.tag,
  });

  factory ArticleTag.fromJson(Map<String, dynamic> json) {
    return ArticleTag(
      articleId: json['articleId'],
      article: json['article'] != null ? Article.fromJson(json['article']) : null,
      tagId: json['tagId'],
      tag: json['tag'] != null ? Tag.fromJson(json['tag']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'articleId': articleId,
      'article': article?.toJson(),
      'tagId': tagId,
      'tag': tag?.toJson(),
    };
  }
}
