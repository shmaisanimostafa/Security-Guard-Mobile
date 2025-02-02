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
    if (userData == null || userData!['imageURL'] == null) {
      return ''; // Return an empty string if the image URL is not available
    }
    return userData!['imageURL']; // Adjust the key according to your API response
  }

  // Method to fetch the profile image URL asynchronously
  Future<String> fetchProfileImageUrl() async {
    if (_token == null) {
      return ''; // Return an empty string if the token is not available
    }

    try {
      final data = await _authService.getUserData(_token!);
      if (data.containsKey('Message')) {
        print('Error fetching user data: ${data['Message']}');
        return ''; // Return an empty string if there's an error
      } else {
        return data['imageURL'] ?? ''; // Return the image URL or an empty string
      }
    } catch (e) {
      print('Error fetching profile image URL: $e');
      return ''; // Return an empty string if there's an error
    }
  }

  Future<void> register(String username, String email, String password, String confirmPassword) async {
    try {
      final response = await _authService.register(username, email, password, confirmPassword);
      if (response['message'] == 'User registered successfully') {
        print('Registration successful');
        // Automatically log in the user after successful registration
        await login(username, password);
      } else {
        throw Exception(response['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw e; // Re-throw the exception to handle it in the UI
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
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
      throw e; // Re-throw the exception to handle it in the UI
    }
  }

Future<void> updateProfile(Map<String, dynamic> updatedData, String token) async {
  try {
    final response = await _authService.updateProfile(
      token, // Add the token here
      updatedData['username'] as String,
      updatedData['email'] as String,
      updatedData['firstName'] as String,
      updatedData['lastName'] as String,
      updatedData['imageURL'] as String,  // Make sure this is passed correctly
    );
    if (response['message'] == 'Profile updated successfully') {
      await fetchUserData(); // Refresh user data
    } else {
      throw Exception(response['message'] ?? 'Failed to update profile');
    }
  } catch (e) {
    print('Error updating profile: $e');
    throw e;
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