import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/models/mongo_message.dart';
import 'package:capstone_proj/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signalr_netcore/signalr_client.dart';

class MongoMessageAPIHandler {
  final String _baseUrl = "$apiBaseUrl/api/MongoMessages"; // MongoDB API URL
  final String _signalRUrl = "$apiBaseUrl/chatHub"; // SignalR Hub URL
  final AuthProvider authProvider; // Add AuthProvider as a dependency

  MongoMessageAPIHandler({required this.authProvider}); // Constructor

  late HubConnection hubConnection;

  Future<void> initializeSignalR(Function(MongoMessage) onNewMessage) async {
    hubConnection = HubConnectionBuilder().withUrl(_signalRUrl).build();

    hubConnection.onclose((error) {
      print("SignalR connection closed: $error");
    } as ClosedCallback);

    hubConnection.on('ReceiveMessage', (arguments) {
      final newMessage = MongoMessage.fromJson(arguments![0] as Map<String, dynamic>);
      onNewMessage(newMessage); // Call the passed callback
    });

    await hubConnection.start();
    print("SignalR connected successfully.");
  }

  // Fetch All MongoMessages
  Future<List<MongoMessage>> getMessages() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => MongoMessage.fromJson(item)).toList();
    } else {
      throw Exception("Can't get messages.");
    }
  }

  // Fetch Single MongoMessage
  Future<MongoMessage> getMessage(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/$id"));
    if (response.statusCode == 200) {
      return MongoMessage.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Can't get message.");
    }
  }

  // Add MongoMessage
  Future<MongoMessage> addMessage(MongoMessage message) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 201) {
      final newMessage = MongoMessage.fromJson(jsonDecode(response.body));

      // Ensure the connection is established before sending the message
      if (hubConnection.state == HubConnectionState.Connected) {
        await hubConnection.invoke(
          "SendMessage",
          args: [newMessage.sender, newMessage.receiver, newMessage.content],
        );
      } else {
        print("SignalR connection is not in the 'Connected' state.");
      }

      return newMessage;
    } else {
      throw Exception("Can't post message.");
    }
  }

  // Add AI-Generated Message
  Future<MongoMessage> addMongoMessageAI(String question) async {
    // Create a new MongoMessage for the AI response
    final aiMessage = MongoMessage(
      sender: authProvider.userData?['username'], // Sender is set to the current user
      receiver: 'AI', // Receiver is set to 'AI'
      content: question, // The AI-generated question or response
      isAi: true, // Mark the message as AI-generated
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Send the AI message to the MongoDB API
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(aiMessage.toJson()),
    );

    if (response.statusCode == 201) {
      final newMessage = MongoMessage.fromJson(jsonDecode(response.body));

      // Ensure the connection is established before sending the message
      if (hubConnection.state == HubConnectionState.Connected) {
        await hubConnection.invoke(
          "SendMessage",
          args: [newMessage.sender, newMessage.receiver, newMessage.content],
        );
      } else {
        print("SignalR connection is not in the 'Connected' state.");
      }

      return newMessage;
    } else {
      throw Exception("Can't post AI message.");
    }
  }

  // Update MongoMessage
  Future<void> updateMessage(String id, MongoMessage updatedMessage) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedMessage.toJson()),
    );

    if (response.statusCode == 204) {
      // Ensure the connection is established before sending the message
      if (hubConnection.state == HubConnectionState.Connected) {
        await hubConnection.invoke(
          "UpdateMessage",
          args: [updatedMessage.toJson()],
        );
      } else {
        print("SignalR connection is not in the 'Connected' state.");
      }
    } else {
      throw Exception("Can't update message.");
    }
  }

  // Delete MongoMessage
  Future<void> deleteMessage(String id) async {
    final response = await http.delete(Uri.parse("$_baseUrl/$id"));

    if (response.statusCode == 204) {
      // Ensure the connection is established before sending the message
      if (hubConnection.state == HubConnectionState.Connected) {
        await hubConnection.invoke(
          "DeleteMessage",
          args: [id],
        );
      } else {
        print("SignalR connection is not in the 'Connected' state.");
      }
    } else {
      throw Exception("Can't delete message.");
    }
  }

  // Listen for Real-Time SignalR Messages
  void onNewMessage(Function(MongoMessage) callback) {
    hubConnection.on('ReceiveMessage', (arguments) {
      final newMessage = MongoMessage.fromJson(arguments![0] as Map<String, dynamic>);
      callback(newMessage);
    });
  }

  // Dispose SignalR Hub Connection
  Future<void> dispose() async {
    await hubConnection.stop();
    print("SignalR connection stopped.");
  }
}