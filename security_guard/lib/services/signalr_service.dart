import 'package:capstone_proj/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final hubConnection = HubConnectionBuilder()
      .withUrl(signalRHubUrl)
      .build();

  static Future<void> startConnection({Function(String, String)? onMessageReceived}) async {
    await hubConnection.start();
    hubConnection.on('ReceiveMessage', (arguments) {
      final user = arguments![0] as String;
      final message = arguments[1] as String;
      if (onMessageReceived != null) {
        onMessageReceived(user, message);
      }
    });
  }

  static Future<void> sendMessage(String user, String message) async {
    await hubConnection.invoke('SendMessage', args: [user, message]);
  }
}