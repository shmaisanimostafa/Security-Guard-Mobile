import 'dart:io';
import 'package:capstone_proj/components.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
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
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      textRecognizing = true;
      setState(() {
        this.image = imageTemporary;
      });
      recognizeText(this.image!);
    } on Exception catch (e) {
      recognizedText = 'Error: $e';
    }
  }

  Future recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textDetector = TextRecognizer();
    final RecognizedText recognizedTextTemp =
        await textDetector.processImage(inputImage);
    await textDetector.close();
    recognizedText = '';
    for (TextBlock block in recognizedTextTemp.blocks) {
      for (TextLine line in block.lines) {
        recognizedText += '${line.text} ';
      }
    }
    setState(() {
      textRecognizing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO Theme shall be the same as the parent, to be edited later
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
      ),
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow),
      ), // Shall
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                          width: 200,
                          height: 200,
                        ),
                      )
                    : const Text(
                        'No image selected',
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(height: 20.0),
                textRecognizing
                    ? const CircularProgressIndicator()
                    : Text(recognizedText),
                const SizedBox(height: 20.0),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  child: const UploadBox(
                    boxText: 'Upload Image Here',
                    backColor: Colors.amber,
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
                ElevatedButton(
                  onPressed: () {
                    // debugPrint('Scan');
                    // Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 10.0),
                      Text('Capture Image'),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
