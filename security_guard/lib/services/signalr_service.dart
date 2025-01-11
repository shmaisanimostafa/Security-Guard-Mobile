import 'package:capstone_proj/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final hubConnection = HubConnectionBuilder()
      .withUrl(signalRHubUrl)
      .build();

static Future<void> startConnection({Function(String, String)? onMessageReceived}) async {
  hubConnection.onclose((error) {
    print("SignalR connection closed: $error");
    _reconnect(onMessageReceived: onMessageReceived);
  } as ClosedCallback);
  await hubConnection.start();
}

static Future<void> _reconnect({Function(String, String)? onMessageReceived}) async {
  const maxAttempts = 5;
  int attempts = 0;

  while (hubConnection.state != HubConnectionState.Connected && attempts < maxAttempts) {
    attempts++;
    print("Attempting to reconnect... ($attempts/$maxAttempts)");
    await Future.delayed(const Duration(seconds: 2));
    try {
      await hubConnection.start();
      print("Reconnected to SignalR.");
      if (onMessageReceived != null) {
        hubConnection.on('ReceiveMessage', (arguments) {
          final user = arguments![0] as String;
          final message = arguments[1] as String;
          onMessageReceived(user, message);
        });
      }
      break;
    } catch (e) {
      print("Reconnect attempt failed: $e");
    }
  }

  if (hubConnection.state != HubConnectionState.Connected) {
    print("Failed to reconnect to SignalR after $maxAttempts attempts.");
  }
}



static Future<void> sendMessage(String user, String message) async {
  if (hubConnection.state == HubConnectionState.Connected) {
    try {
      await hubConnection.invoke('SendMessage', args: [user, message]);
    } catch (e) {
      print("Error sending message: $e");
    }
  } else {
    print("SignalR connection is not active. Unable to send message.");
  }
}

static Future<void> stopConnection() async {
  if (hubConnection.state == HubConnectionState.Connected) {
    await hubConnection.stop();
    print("SignalR connection stopped.");
  }
}

}