import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on Exception catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image != null
              ? Image.file(
                  image!,
                  width: 200,
                  height: 200,
                )
              : const Text('No image selected'),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // debugPrint('Scan');
              // Navigator.pop(context);
              pickImage();
            },
            child: const Text('Upload Image'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // debugPrint('Scan');
              // Navigator.pop(context);
            },
            child: const Text('Capture Image'),
          ),
        ],
      )),
    );
  }
}
