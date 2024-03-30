import 'dart:io';
import 'package:capstone_proj/components/upload_box.dart';
import 'package:capstone_proj/functions/link_regex.dart';
import 'package:capstone_proj/functions/pick_image.dart';
import 'package:capstone_proj/functions/text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  // For loading widget
  bool textRecognizing = false;
  // The picked up Image
  File? image;
  // The recognized text
  String recognizedText = '';

//
// Image picker method
//
  void pickAndRecognizeImage(ImageSource source) async {
    final imageFile = await pickImage(source);
    if (imageFile != null) {
      textRecognizing = true;
      setState(() {
        image = imageFile;
      });
      recognizedText = await recognizeText(image!);
      setState(() {
        textRecognizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to Text Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(
                          image!,
                          width: 400,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text(
                        'No image selected',
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(height: 20.0),
                textRecognizing
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(recognizedText),
                          const SizedBox(height: 20.0),
                          Text(
                            extractLink(recognizedText),
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 20.0),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    pickAndRecognizeImage(ImageSource.gallery);
                  },
                  child: const UploadBox(
                    boxText: 'Upload Image',
                    backColor: Colors.amberAccent,
                    dotColor: Colors.grey,
                    icon: Icons.image_search_rounded,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'OR',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    pickAndRecognizeImage(ImageSource.camera);
                  },
                  child: const UploadBox(
                    boxText: 'Capture Image',
                    backColor: Colors.redAccent,
                    dotColor: Colors.grey,
                    icon: Icons.camera_enhance,
                  ),
                ),
                // const SizedBox(height: 20.0),
                // ElevatedButton(
                //   onPressed: () {
                //     pickImage(ImageSource.camera);
                //   },
                //   child: const Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(Icons.camera_alt),
                //       SizedBox(width: 10.0),
                //       Text('Capture Image'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
