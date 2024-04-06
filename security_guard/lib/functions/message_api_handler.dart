import 'package:capstone_proj/models/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageAPIHandler {
  final String _baseUrl = "https://localhost:7244/api/Messages";

  Future<List<Message>> getMessages() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Message> messages = body
          .map(
            (dynamic item) => Message.fromJson(item),
          )
          .toList();
      return messages;
    } else {
      throw "Can't get messages.";
    }
  }

  Future<Message> getMessage(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/$id"));
    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw "Can't get message.";
    }
  }

  Future<Message> postMessage(Message message) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(message.toJson()),
    );
    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw "Can't post message.";
    }
  }
}
