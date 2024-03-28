import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highLights = {
    "Flutter": HighlightedWord(
      onTap: () {
        // print("Flutter");
      },
      textStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "open-source": HighlightedWord(
      onTap: () {
        // print("open-source");
      },
      textStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Android": HighlightedWord(
      onTap: () {
        // print("Android");
      },
      textStyle: const TextStyle(
        color: Colors.green,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Malware": HighlightedWord(
      onTap: () {
        // print("Malware");
      },
      textStyle: const TextStyle(
        color: Colors.red,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Security": HighlightedWord(
      onTap: () {
        // print("Security");
      },
      textStyle: const TextStyle(
        color: Colors.yellow,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          // onStatus: (val) => print('onStatus: $val'),
          // onError: (val) => print('onError: $val'),
          );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 196, 0, 0.498),
      appBar: AppBar(
        title: Text('Confidence: ${_confidence * 100.0}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        glowRadiusFactor: 5.0,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        // repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed: () {
            _listen();
          },
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highLights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
