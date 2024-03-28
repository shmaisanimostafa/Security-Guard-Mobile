import 'package:capstone_proj/components/upload_box.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      //SECTION - AppBar
      //
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      //
      //SECTION - Body
      //
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Function to upload file
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const UploadBox(
                boxText: 'Upload File Here',
                backColor: Colors.amber,
                dotColor: Colors.grey,
                icon: Icons.upload_file,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
