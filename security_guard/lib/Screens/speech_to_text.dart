import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';

class SpeechScreen extends StatefulWidget {
  final Function(String) onTextRecognized; // Callback to send recognized text

  const SpeechScreen({super.key, required this.onTextRecognized});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highLights = {
    "Flutter": HighlightedWord(
      onTap: () {},
      textStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "open-source": HighlightedWord(
      onTap: () {},
      textStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Android": HighlightedWord(
      onTap: () {},
      textStyle: const TextStyle(
        color: Colors.green,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Malware": HighlightedWord(
      onTap: () {},
      textStyle: const TextStyle(
        color: Colors.red,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Security": HighlightedWord(
      onTap: () {},
      textStyle: const TextStyle(
        color: Colors.yellow,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _isInitializing = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  // Controller for the editable text field
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissions().then((_) {
      _initializeSpeech();
    });
  }

  Future<void> _checkPermissions() async {
    // Use a MethodChannel to request permissions from the native side
    const channel = MethodChannel('com.example.app/permissions');
    try {
      final bool hasPermission = await channel.invokeMethod('checkRecordAudioPermission');
      if (!hasPermission) {
        await channel.invokeMethod('requestRecordAudioPermission');
      }
    } catch (e) {
      print('Error checking or requesting permissions: $e');
    }
  }

  void _initializeSpeech() async {
    setState(() {
      _isInitializing = true;
    });
    try {
      _speechAvailable = await _speech.initialize(
        debugLogging: true, // Enable debug logging
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
    } catch (e) {
      print('Error initializing speech: $e');
      _speechAvailable = false;
    }
    setState(() {
      _isInitializing = false;
    });
    if (!_speechAvailable) {
      setState(() {
        _text = 'Speech recognition not available';
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _text = ''; // Clear previous text
        _textController.clear(); // Clear the text field
      });
      try {
        await _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            _textController.text = _text; // Update the text field with recognized text
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      } catch (e) {
        setState(() {
          _isListening = false;
          _text = 'Error: ${e.toString()}';
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void _sendRecognizedText() {
    final textToSend = _textController.text.trim(); // Get the text from the text field
    if (textToSend.isNotEmpty) {
      widget.onTextRecognized(textToSend); // Send the text
      Navigator.pop(context); // Close the SpeechScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isInitializing
          ? CircularProgressIndicator()
          : AvatarGlow(
              animate: _isListening,
              glowColor: Theme.of(context).primaryColor,
              glowRadiusFactor: 5.0,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              child: FloatingActionButton(
                onPressed: _speechAvailable ? _listen : null,
                child: Icon(_isListening ? Icons.mic : Icons.mic_off),
              ),
            ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            _isListening
                ? const Text('Listening...', style: TextStyle(color: Colors.green))
                : const Text('Not Listening...', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: TextHighlight(
                text: _text,
                words: _highLights,
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (!_isListening && _text.isNotEmpty) // Show editable text field and "Click to Send" button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit your message',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _sendRecognizedText,
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text(
                        'Click to Send',
                        style: TextStyle(fontSize: 18,
                        //  color: Colors.white
                         ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}