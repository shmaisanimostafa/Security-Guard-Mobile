import 'package:capstone_proj/models/auth_provider.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_proj/Screens/initial_screen_my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MaterialApp(
        home: BetterFeedback(
          child: MyApp(),
        ),
      ),
    ),
  );
}
