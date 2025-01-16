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
          .withUrl(
            signalRHubUrl,
            options: HttpConnectionOptions(
              requestTimeout: 30000, // Increase timeout to 20 seconds
            ),
          )
          .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 30000]) // Retry reconnection with delays
          .build();

      // _hubConnection.onclose((error) {
      //   print("SignalR connection closed: $error");
      //   _isConnected = false;
      //   // Attempt to reconnect
      //   _reconnect();
      // });

      await _hubConnection.start();
      _isConnected = true;

      // Join the group after connection is established
      await _hubConnection.invoke("JoinGroup", args: ["Group1"]); // Replace "Group1" with your actual group name
      print("Joined group: Group1");

      _hubConnection.on("ReceiveMessage", (message) {
        print("Received message: $message"); // Log received messages
        if (message != null && onMessageReceived != null) {
          // Extract the first item from the list
          var messageMap = message[0] as Map<String, dynamic>;
          onMessageReceived!({
            "id": messageMap["id"],
            "sender": messageMap["sender"],
            "receiver": messageMap["receiver"],
            "content": messageMap["content"],
            "timestamp": messageMap["timestamp"],
            "isRead": messageMap["isRead"],
            "isAi": messageMap["isAi"],
          });
        }
      });

      print("SignalR connected successfully!");
    } catch (e) {
      print("Error connecting to SignalR: $e");
      _isConnected = false;
      // Attempt to reconnect
      _reconnect();
    }
  }

  Future<void> _reconnect() async {
    await Future.delayed(Duration(seconds: 5)); // Wait 5 seconds before reconnecting
    print("Attempting to reconnect...");
    await connect();
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