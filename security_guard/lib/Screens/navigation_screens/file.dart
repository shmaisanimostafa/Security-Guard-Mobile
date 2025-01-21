import 'package:capstone_proj/components/upload_box.dart';
import 'package:capstone_proj/functions/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen>
    with SingleTickerProviderStateMixin {
  // Initialize empty file
  PlatformFile file = PlatformFile(
    name: '',
    size: 0,
  );

  // Animation controller for pulsing text
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  // Typing effect variables
  String _displayText = '';
  int _textIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start typing effect
    _startTypingEffect();
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  // Typing effect logic
  void _startTypingEffect() {
    const fullText = 'This feature is coming soon!';
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_textIndex < fullText.length) {
        setState(() {
          _displayText = fullText.substring(0, _textIndex + 1);
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

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
      body: Stack(
        children: [
          // Existing UI
          Center(
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

          // Overlay with "Coming Soon" message
          AnimatedOpacity(
            opacity: 1.0, // Fully visible
            duration: const Duration(seconds: 1),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Typing effect text (non-interactive)
                  IgnorePointer(
                    child: Text(
                      _displayText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pulsating "Coming Soon" text
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: const Text(
                      'Coming Soon',
                      style: TextStyle(
                        color: Colors.yellow, // Yellow color
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Floating icons (optional, non-interactive)
                  const SizedBox(height: 20),
                  IgnorePointer(
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}