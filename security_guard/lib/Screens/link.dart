import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  const Link({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Enter the link'),
        ),
        body: const Center(
          child: SizedBox(
            width: 250,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the link here',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
