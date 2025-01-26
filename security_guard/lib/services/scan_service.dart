import 'dart:convert';
import 'package:http/http.dart' as http;

class ScanService {
  static const String baseUrl = "https://localhost:32773/api/ScanAPI";

  // Scan a link
  static Future<Map<String, dynamic>> scanLink(String url, String userName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan-link'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url, 'userName': userName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to scan link');
    }
  }

  // Scan a file
  static Future<Map<String, dynamic>> scanFile(String fileName, String url, String userName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan-file'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fileName': fileName, 'url': url, 'userName': userName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to scan file');
    }
  }

  // Scan an email
  static Future<Map<String, dynamic>> scanEmail(String emailMessage, String userName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailMessage': emailMessage, 'userName': userName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to scan email');
    }
  }
}