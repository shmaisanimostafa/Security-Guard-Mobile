import 'dart:convert';
import 'package:capstone_proj/constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Define the base URL for the API
  static const String _baseUrl = apiBaseUrl;

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

    print('Register Response status: ${response.statusCode}');
    print('Register Response body: ${response.body}');

    try {
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return {'Message': responseData['Message'] ?? 'Registration failed'};
      }
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username, 'Password': password}),
    );

    print('Login Response status: ${response.statusCode}');
    print('Login Response body: ${response.body}');

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        return {'Message': errorResponse['Message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Get User Data
  Future<Map<String, dynamic>> getUserData(String token) async {
  if (token.isEmpty) {
    return {'Message': 'Token is required'};
  }

  try {
    // Include the token as a query parameter in the URL
    final url = Uri.parse('$_baseUrl/api/auth/user-data?token=$token');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Request URL: $url');
    print('Get User Data Response status: ${response.statusCode}');
    print('Get User Data Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorResponse = json.decode(response.body);
      return {'Message': errorResponse['title'] ?? 'Failed to load user data'};
    }
  } catch (e) {
    print('Exception: $e');
    return {'Message': 'Failed to load user data'};
  }
}

  // Refresh Token
  Future<Map<String, dynamic>> refreshToken(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'token': token}),
    );

    print('Refresh Token Response status: ${response.statusCode}');
    print('Refresh Token Response body: ${response.body}');

    try {
      return json.decode(response.body);
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Update Profile
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

    print('Update Profile Response status: ${response.statusCode}');
    print('Update Profile Response body: ${response.body}');

    try {
      return json.decode(response.body);
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Request Password Reset Token
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    print('Forgot Password Response status: ${response.statusCode}');
    print('Forgot Password Response body: ${response.body}');

    try {
      return json.decode(response.body);
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Reset Password
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

    print('Reset Password Response status: ${response.statusCode}');
    print('Reset Password Response body: ${response.body}');

    try {
      return json.decode(response.body);
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Delete Account
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

    print('Delete Account Response status: ${response.statusCode}');
    print('Delete Account Response body: ${response.body}');

    try {
      return json.decode(response.body);
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }

  // Get User Info by User ID
  Future<Map<String, dynamic>> getUserInfo(String token, String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/auth/user-info/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Get User Info Response status: ${response.statusCode}');
    print('Get User Info Response body: ${response.body}');

    try {
      return json.decode(response.body);
    } catch (e) {
      print('Error decoding response: $e');
      return {'Message': 'Unexpected error occurred'};
    }
  }
}
