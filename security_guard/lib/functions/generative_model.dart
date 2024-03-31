// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> geminiGenerate(String prompt) async {
  // Access your API key as an environment variable (see "Set up your API key" above)
  const apiKey = 'AIzaSyAF6af3QUa2Kvu9UaUyMtusmajXiSrw5lQ';
  // Platform.environment[];
  // if (apiKey == null) {
  //   debugPrint('No \$API_KEY environment variable');
  //   exit(1);
  // }
  // For text-only input, use the gemini-pro model
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  debugPrint(response.text);
  return response.text.toString();
}
