import 'dart:async';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/providers/auth_provider.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalRService {
  final AuthProvider authProvider;

  SignalRService(this.authProvider);

  late HubConnection hubConnection;
  final Completer<void> _connectionCompleter = Completer<void>(); // Tracks connection status

  // Public getter to check if the connection is ready
  Future<void> get isConnectionReady => _connectionCompleter.future;

  Future<void> startConnection({Function(String, String)? onMessageReceived}) async {
    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Ensure the token is loaded
        if (authProvider.token == null) {
          print('Token is not available. Loading token...');
          await authProvider.loadToken();
        }

        // Build the connection with headers
        hubConnection = HubConnectionBuilder()
            .withUrl(
              signalRHubUrl,
              options:HttpConnectionOptions(
                // logger: (level, message) => print('SignalR Log: $level - $message'),
                // headers: {
                //   'Authorization': 'Bearer ${authProvider.token ?? ''}',
                // },
              ),
            )
            .build();

        // Handle connection closed event
        hubConnection.onclose(({Exception? error}) {
          print("SignalR connection closed: $error");
          _reconnect(onMessageReceived: onMessageReceived);
        } as ClosedCallback);

        // Handle reconnecting event
        hubConnection.onreconnecting(({Exception? error}) {
          print("SignalR reconnecting: $error");
        });

        // Handle reconnected event
        hubConnection.onreconnected(({String? connectionId}) {
          print("SignalR reconnected. Connection ID: $connectionId");
        });

        // Set up the message listener
        hubConnection.on('ReceiveMessage', (arguments) {
          if (arguments != null && arguments.isNotEmpty) {
            try {
              final message = arguments[0] as Map<String, dynamic>;
              final user = message['Sender'] as String;
              final content = message['Content'] as String;
              if (onMessageReceived != null) {
                onMessageReceived(user, content);
              }
            } catch (e) {
              print("Error parsing message: $e");
            }
          } else {
            print("Invalid message format received: $arguments");
          }
        });

        // Start the connection
        await hubConnection.start();
        print('SignalR Connected!');
        _connectionCompleter.complete(); // Signal that the connection is ready
        break; // Exit the retry loop on success
      } catch (e) {
        retryCount++;
        print('Failed to start SignalR connection (Attempt $retryCount/$maxRetries): $e');
        if (retryCount == maxRetries) {
          _connectionCompleter.completeError(e);
        }
        await Future.delayed(Duration(seconds: 2)); // Wait before retrying
      }
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

  Future<void> _reconnect({Function(String, String)? onMessageReceived}) async {
    const maxAttempts = 5;
    int attempts = 0;

    while (hubConnection.state != HubConnectionState.Connected && attempts < maxAttempts) {
      attempts++;
      final delay = Duration(seconds: 2 * attempts); // Exponential backoff
      print("Attempting to reconnect... ($attempts/$maxAttempts) in ${delay.inSeconds} seconds");
      await Future.delayed(delay);

      try {
        await hubConnection.start();
        print("Reconnected to SignalR.");
        if (onMessageReceived != null) {
          hubConnection.on('ReceiveMessage', (arguments) {
            if (arguments != null) {
              final message = arguments[0] as Map<String, dynamic>;
              final user = message['Sender'];
              final content = message['Content'];
              onMessageReceived(user, content);
            }
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
}