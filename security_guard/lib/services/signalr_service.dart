import 'dart:async';

import 'package:capstone_proj/models/auth_provider.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:capstone_proj/constants.dart';

class SignalRService {
  final AuthProvider authProvider;

  SignalRService(this.authProvider);

  late HubConnection hubConnection;
  final Completer<void> _connectionCompleter = Completer<void>(); // Tracks connection status

  Future<void> startConnection({Function(String, String)? onMessageReceived}) async {
    // Ensure the token is loaded
    if (authProvider.token == null) {
      print('Token is not available. Loading token...');
      await authProvider.loadToken();
    }

    if (authProvider.token == null) {
      throw Exception('No token available');
    }

    hubConnection = HubConnectionBuilder()
        .withUrl(
          signalRHubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              final token = authProvider.token;
              if (token == null) {
                throw Exception('No token available');
              }
              print('Using token: $token');
              return token;
            },
            // logging: (level, message) => print('SignalR Log: $level - $message'),
            requestTimeout: 20000, // Increased timeout
          ),
        )
        .build();

    // Define the onclose callback with the correct signature
    void _onCloseCallback({Exception? error}) {
      print("SignalR connection closed: $error");
      _reconnect(onMessageReceived: onMessageReceived);
    }

    // Set the onclose callback
    hubConnection.onclose(_onCloseCallback);

    // Set up the message listener
    hubConnection.on('ReceiveMessage', (arguments) {
      print('Received message: $arguments');
      if (onMessageReceived != null) {
        final message = arguments?[0] as dynamic;
        final user = message['Sender'];
        final content = message['Content'];
        onMessageReceived(user, content);
      }
    });

    try {
      await hubConnection.start();
      print('SignalR Connected!');
      _connectionCompleter.complete(); // Signal that the connection is ready
    } catch (e) {
      print('Failed to start SignalR connection: $e');
      _connectionCompleter.completeError(e); // Signal that the connection failed
    }
  }

  Future<void> _reconnect({Function(String, String)? onMessageReceived}) async {
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
            final message = arguments?[0] as dynamic;
            final user = message['Sender'];
            final content = message['Content'];
            onMessageReceived(user, content);
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

  Future<void> sendMessage(String user, String message) async {
    // Wait for the connection to be ready
    if (!_connectionCompleter.isCompleted) {
      print('Waiting for SignalR connection to be ready...');
      await _connectionCompleter.future;
    }

    if (hubConnection.state != HubConnectionState.Connected) {
      print("SignalR connection is not active. Unable to send message.");
      return;
    }

    try {
      await hubConnection.invoke('SendMessage', args: [user, 'receiver', message]);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> stopConnection() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.stop();
      print("SignalR connection stopped.");
    }
  }
}