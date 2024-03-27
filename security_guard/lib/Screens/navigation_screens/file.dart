import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  @override
  Widget build(BuildContext context) {
    String fileName = '';
    String filePath = '';
    String fileSize = '';
    String fileExtension = '';
    PlatformFile file;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('File Name: $fileName'),
            Text('File Path: $filePath'),
            Text('File Size: $fileSize KB'),
            Text('File Extension: $fileExtension'),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // The File Upload Functionality

                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  file = result.files.first;
                  setState(() {
                    fileName = file.name;
                    filePath = file.path!;
                    fileSize = (file.size / 1024).toStringAsFixed(2);
                    fileExtension = file.extension!;
                  });
                } else {
                  // User canceled the picker
                }
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                dashPattern: const [10, 10],
                color: Colors.grey,
                strokeWidth: 2,
                child: Card(
                  margin: const EdgeInsets.all(20),
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file,
                              size: 50.0, color: Colors.black),
                          Text("Upload File Here"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
