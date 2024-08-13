import 'package:capstone_proj/Screens/initial_screen_my_app.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: BetterFeedback(
        child: MyApp(),
      ),
    ),
  );
}
