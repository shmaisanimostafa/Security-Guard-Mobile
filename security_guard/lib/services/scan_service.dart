import 'dart:convert';
import 'package:capstone_proj/constants.dart';
import 'package:http/http.dart' as http;

class ScanService {
  static const String baseUrl = apiBaseUrl + "/api/ScanAPI";

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

  // Scan text (email)
  static Future<Map<String, dynamic>> scanText(String text, String userName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scan-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailMessage': text, 'userName': userName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to scan text');
    }
  }
}