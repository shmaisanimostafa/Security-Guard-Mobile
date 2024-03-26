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

//
// Image picker method
//
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
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
          title: const Text('Image to Text Converter'),
        ),
        body: Center(
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
                : const Text('No image selected'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // debugPrint('Scan');
                // Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // debugPrint('Scan');
                // Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
              child: const Text('Capture Image'),
            ),
          ],
        )),
      ),
    );
  }
}
