import 'package:flutter/material.dart';

class Scan extends StatelessWidget {
  const Scan({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        debugPrint('Scan');
        Navigator.pop(context);
      },
      child: const Text('Return'),
    ));
  }
}
