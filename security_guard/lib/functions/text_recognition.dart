import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> recognizeText(File image) async {
  final inputImage = InputImage.fromFile(image);
  final textDetector = TextRecognizer();
  final RecognizedText recognizedTextTemp =
      await textDetector.processImage(inputImage);
  await textDetector.close();
  String recognizedText = '';
  for (TextBlock block in recognizedTextTemp.blocks) {
    for (TextLine line in block.lines) {
      recognizedText += '${line.text} ';
    }
  }
  return recognizedText;
}
