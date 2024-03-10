import 'package:flutter/material.dart';

class File extends StatelessWidget {
  const File({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Select File'),
          onPressed: () {},
        ),
      ),
    );
  }
}
