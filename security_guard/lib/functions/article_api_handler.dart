import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:capstone_proj/models/comment.dart';
import 'package:capstone_proj/models/article.dart';
import 'package:capstone_proj/constants.dart';

class ArticleAPIHandler {
  final String _baseUrl = "$apiBaseUrl/api/Articles";

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      // Decode the JSON response
      List<dynamic> body = jsonDecode(response.body);

      // Map the JSON data to the Article model
      List<Article> articles = body.map((dynamic item) {
        return Article.fromJson(item);
      }).toList();

      return articles;
    } else {
      throw "Failed to load articles. Status code: ${response.statusCode}";
    }
  }

  Future<Article> getArticle(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/$id"));

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to load article. Status code: ${response.statusCode}";
    }
  }

 Future<void> addComment(int articleId, String content, String author) async {
  final payload = {
    'author': author,
    'content': content,
  };

  final response = await http.post(
    Uri.parse("$_baseUrl/$articleId/Comments"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  if (response.statusCode != 201) {
    // throw "Failed to add comment. Status code: ${response.statusCode}. Response: ${response.body}";
  }
  
}

}