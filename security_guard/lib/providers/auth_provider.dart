import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:capstone_proj/models/auth_service.dart'; // Ensure this path is correct

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  String? _token;

  AuthProvider() {
    _initialize();
  }

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  Future<void> _initialize() async {
    await loadToken(); // Use the public method
  }

  // Public method to load the token
  Future<void> loadToken() async {
    try {
      _token = await _storage.read(key: 'jwt_token');
      print('Loaded token: $_token');
      notifyListeners();
    } catch (e) {
      print('Error loading token: $e');
    }
  }

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<void> fetchUserData() async {
    if (_token == null) {
      print('Token is not available');
      return;
    }

    try {
      final data = await _authService.getUserData(_token!);
      if (data.containsKey('Message')) {
        print('Error fetching user data: ${data['Message']}');
      } else {
        _userData = data;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Get the profile image URL from the user data
  String get profileImageUrl {
    if (userData == null) {
      return '';
    }
    return userData!['imageURL']; // Adjust the key according to your API response
  }

  Future<void> register(String username, String email, String password, String confirmPassword) async {
    try {
      final response = await _authService.register(username, email, password, confirmPassword);
      if (response['Message'] == 'User registered successfully') {
        print('Registration successful');
      } else {
        throw Exception(response['Message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

 Future<void> login(String username, String password) async {
  try {
    final response = await _authService.login(username, password);
    print('Login response: $response');
    if (response.containsKey('token')) {
      _token = response['token']; // Ensure this key matches your API response
      await _storage.write(key: 'jwt_token', value: _token!);
      print('Token saved: $_token');
      notifyListeners(); // Notify listeners after successful login
    } else {
      throw Exception(response['Message'] ?? 'Login failed');
    }
  } catch (e) {
    print('Error during login: $e');
  }
}

  Future<void> logout() async {
    try {
      _token = null;
      await _storage.delete(key: 'jwt_token');
      print('Token deleted');
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}