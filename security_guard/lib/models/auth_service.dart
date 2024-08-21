import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Define the base URL for the API
  static const String _baseUrl = 'https://localhost:7244';

  // Register a new user
  Future<Map<String, dynamic>> register(String username, String email, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    return json.decode(response.body);
  }

  // Login a user and receive a JWT token
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return json.decode(response.body);
  }

  // Refresh the JWT token
  Future<Map<String, dynamic>> refreshToken(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token}),
    );

    return json.decode(response.body);
  }

  // Update user profile information
  Future<Map<String, dynamic>> updateProfile(String token, String username, String email, String firstName, String lastName, String imageURL) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/auth/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'imageURL': imageURL,
      }),
    );

    return json.decode(response.body);
  }

  // Request a password reset token
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    return json.decode(response.body);
  }

  // Reset the user's password
  Future<Map<String, dynamic>> resetPassword(String email, String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'token': token,
        'newPassword': newPassword,
      }),
    );

    return json.decode(response.body);
  }

  // Delete a user account
  Future<Map<String, dynamic>> deleteAccount(String token, String username, String password) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/auth/delete-account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return json.decode(response.body);
  }

  // Get user information by user ID
  Future<Map<String, dynamic>> getUserInfo(String token, String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/auth/user-info/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return json.decode(response.body);
  }
}
