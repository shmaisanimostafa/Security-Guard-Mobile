import 'dart:core';

import 'package:flutter/material.dart';

String extractLink(String text) {
  RegExp linkRegex = RegExp(
      r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
  Match? match = linkRegex.firstMatch(text);
  return match?.group(0) ?? '';
}

void main() {
  String text = 'This is a sample text with a link: https://example.com';
  String link = extractLink(text);
  debugPrint('Link found: $link');
}
