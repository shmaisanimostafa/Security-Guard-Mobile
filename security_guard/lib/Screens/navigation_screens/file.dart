import 'package:capstone_proj/components/upload_box.dart';
import 'package:capstone_proj/functions/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  // Initialize empty file
  PlatformFile file = PlatformFile(
    name: '',
    size: 0,
  );
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
            file.name.isEmpty
                ? const Text('No file selected')
                : Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('File Name'),
                          subtitle: Text(file.name),
                        ),
                        ListTile(
                          title: const Text('File Size'),
                          subtitle: Text(
                              '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB'),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Function to upload file

                pickFile().then((value) {
                  setState(() {
                    file = value;
                  });
                });
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
