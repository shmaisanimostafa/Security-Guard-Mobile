import 'package:capstone_proj/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection _hubConnection;
  bool _isConnected = false;

  // Callbacks
  Function(Map<String, dynamic>)? onMessageReceived;
  Function(String)? onMessageRead;
  Function(String)? onUserTyping;
  Function(String)? onUserStoppedTyping;
  Function(Map<String, dynamic>)? onMessageEdited;
  Function(String)? onMessageDeleted;
  Function(Map<String, dynamic>)? onMessageReacted;
  Function(Map<String, dynamic>)? onFileReceived;

  Future<void> connect() async {
    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            signalRHubUrl,
            options: HttpConnectionOptions(
              requestTimeout: 30000,
            ),
          )
          .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 30000])
          .build();

      await _hubConnection.start();
      _isConnected = true;

      await _hubConnection.invoke("JoinGroup", args: ["Group1"]);
      print("SignalR connected successfully and joined group: Group1");

      // Handle incoming messages
      _hubConnection.on("ReceiveMessage", (message) {
        print("Received message: $message");
        if (message != null && onMessageReceived != null) {
          var messageMap = Map<String, dynamic>.from(message[0] as Map<dynamic, dynamic>);
          print("Processed message: $messageMap");
          onMessageReceived!(messageMap);
        }
      });

      // Handle other events
      _hubConnection.on("MessageRead", (messageId) {
        print("Message read: $messageId");
        if (onMessageRead != null) {
          onMessageRead!(messageId as String);
        }
      });

      _hubConnection.on("UserTyping", (userId) {
        print("User typing: $userId");
        if (onUserTyping != null) {
          onUserTyping!(userId as String);
        }
      });

      _hubConnection.on("UserStoppedTyping", (userId) {
        print("User stopped typing: $userId");
        if (onUserStoppedTyping != null) {
          onUserStoppedTyping!(userId as String);
        }
      });

      _hubConnection.on("MessageEdited", (message) {
        print("Message edited: $message");
        if (onMessageEdited != null) {
          onMessageEdited!(Map<String, dynamic>.from(message?[0] as Map<dynamic, dynamic>));
        }
      });

      _hubConnection.on("MessageDeleted", (messageId) {
        print("Message deleted: $messageId");
        if (onMessageDeleted != null) {
          onMessageDeleted!(messageId as String);
        }
      });

      _hubConnection.on("MessageReacted", (reaction) {
        print("Message reacted: $reaction");
        if (onMessageReacted != null) {
          onMessageReacted!(Map<String, dynamic>.from(reaction?[0] as Map<dynamic, dynamic>));
        }
      });

      _hubConnection.on("ReceiveFile", (file) {
        print("File received: $file");
        if (onFileReceived != null) {
          onFileReceived!(Map<String, dynamic>.from(file?[0] as Map<dynamic, dynamic>));
        }
      });

      print("SignalR connected successfully!");
    } catch (e) {
      print("Error connecting to SignalR: $e");
      _isConnected = false;
      _reconnect();
    }
  }

  Future<void> _reconnect() async {
    await Future.delayed(Duration(seconds: 5));
    print("Attempting to reconnect...");
    await connect();
  }

  Future<void> sendMessage(String sender, String receiver, String content, bool isAi) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("SendMessage", args: [sender, receiver, content, isAi]);
  }

  Future<void> markMessageAsRead(String messageId) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("MarkMessageAsRead", args: [messageId]);
  }

  Future<void> startTyping(String groupName) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("StartTyping", args: [groupName]);
  }

  Future<void> stopTyping(String groupName) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("StopTyping", args: [groupName]);
  }

  Future<void> editMessage(String messageId, String newContent) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("EditMessage", args: [messageId, newContent]);
  }

  Future<void> deleteMessage(String messageId) async {
    if (!_isConnected) {
      print("SignalR connection not established. Attempting to reconnect...");
      await connect(); // Attempt to reconnect
    }

    try {
      // Call the EditMessage endpoint to update the message content
      await _hubConnection.invoke("EditMessage", args: [messageId, "Message Deleted!"]);
      print("Message content updated to 'Message Deleted!': $messageId");
    } catch (e) {
      print("Error updating message content: $e");
      // Attempt to reconnect and retry the operation
      await _reconnect();
      await deleteMessage(messageId); // Retry the operation
    }
  }

  Future<void> reactToMessage(String messageId, String reaction) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("ReactToMessage", args: [messageId, reaction]);
  }

  Future<void> sendFile(String sender, String receiver, String fileUrl, String fileName) async {
    if (!_isConnected) return;
    await _hubConnection.invoke("SendFile", args: [sender, receiver, fileUrl, fileName]);
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