import 'dart:convert';
import 'package:capstone_proj/models/article.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  final String _baseUrl = "https://localhost:7244/api/Articles";

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Article> articles = body
          .map(
            (dynamic item) => Article.fromJson(item),
          )
          .toList();
      return articles;
    } else {
      throw "Can't get articles.";
    }
    // List<Article> data = [];
    // final uri = Uri.parse(_baseUrl);
    // try {
    //   final response = await http.get(uri, headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //   });
    //   if (response.statusCode == 200) {
    //     List<dynamic> body = jsonDecode(response.body);
    //     List<Article> articles = body
    //         .map(
    //           (dynamic item) => Article.fromJson(item),
    //         )
    //         .toList();
    //     print(response.body.toString());
    //     return articles;
    //   } else {
    //     print(response.statusCode);
    //     return [];
    //   }
    // } catch (e) {
    //   print(e.toString());
    //   return [];
    // }
  }
}
