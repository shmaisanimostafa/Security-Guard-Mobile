import 'dart:convert';
import 'package:http/http.dart' as http;

class FastAPIService {
  final String baseUrl ;

  FastAPIService(this.baseUrl);

  // Helper function to handle POST requests
  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Function to predict phishing with BERT
  Future<Map<String, dynamic>> predictPhishingBert(String text) async {
    return postRequest('predict-phishing-bert', {'text': text});
  }

  // Function to predict spam
  Future<Map<String, dynamic>> predictSpam(String text) async {
    return postRequest('predict-spam', {'text': text});
  }

  // Function to predict phishing with new model
  Future<Map<String, dynamic>> predictPhishingNew(String text) async {
    return postRequest('predict-phishing-new', {'text': text});
  }
}
