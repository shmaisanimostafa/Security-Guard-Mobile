import 'package:file_picker/file_picker.dart';

Future<PlatformFile> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    PlatformFile file = result.files.first;

    print(file.name);
    print(file.bytes);
    print(file.size);
    print(file.extension);
    print(file.path);
    return file;
  } else {
    //
    //NOTE User canceled the picker, return empty file
    //
    return PlatformFile(
      name: '',
      // bytes: Uint8List(0),
      size: 0,
      // extension: '',
      // path: '',
    );
  }
}
