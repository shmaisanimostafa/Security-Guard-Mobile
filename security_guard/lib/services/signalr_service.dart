import 'package:capstone_proj/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection _hubConnection;
  bool _isConnected = false;

  // Callbacks
  Function(Map<String, dynamic>)? onMessageReceived;

  Future<void> connect() async {
    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(signalRHubUrl,
          options: HttpConnectionOptions(
              // logging: (level, message) => print(message), // Optional logging
              requestTimeout: 20000, // Increase timeout to 10 seconds
            ),
          ) .withAutomaticReconnect()
          .build();

      await _hubConnection.start();
      _isConnected = true;

      _hubConnection.on("ReceiveMessage", (message) {
        if (message != null && onMessageReceived != null) {
          onMessageReceived!({
            "id": message[0],
            "sender": message[1],
            "receiver": message[2],
            "content": message[3],
            "timestamp": message[4],
            "isRead": message[5],
            "isAi": message[6],
          });
        }
      });

      print("SignalR connected successfully!");
    } catch (e) {
      print("Error connecting to SignalR: $e");
      _isConnected = false;
    }
  }

  Future<void> sendMessage(String sender, String receiver, String content, bool isAi) async {
    if (!_isConnected) {
      print("SignalR connection not established.");
      return;
    }

    try {
      await _hubConnection.invoke("SendMessage", args: [sender, receiver, content, isAi]);
      print("Message sent successfully!");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<List<dynamic>> getMessageHistory() async {
    if (!_isConnected) {
      print("SignalR connection not established.");
      return [];
    }

    try {
      var result = await _hubConnection.invoke("GetMessageHistory");
      if (result is List) {
        return result;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching message history: $e");
      return [];
    }
  }

  Future<void> disconnect() async {
    if (_isConnected) {
      await _hubConnection.stop();
      _isConnected = false;
      print("SignalR disconnected.");
    }
  }
}