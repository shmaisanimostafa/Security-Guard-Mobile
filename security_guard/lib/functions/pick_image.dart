import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<File?> pickImage(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;
    return File(image.path);
  } catch (e) {
    // print('Error: $e');
    return null;
  }
}
