import 'package:flutter/material.dart';
import 'package:capstone_proj/Screens/response_safe_screen.dart';
import 'package:capstone_proj/models/fast_api_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final FastAPIService apiService = FastAPIService('http://localhost:8000');
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  Map<String, dynamic>? phishingBertResult;
  Map<String, dynamic>? spamResult;
  Map<String, dynamic>? phishingNewResult;

  bool _isLoading = false;
  bool _isLinkAnalysis = true; // Toggle between link and text analysis

  Future<void> _predictText() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final text = _textController.text;
      phishingBertResult = await apiService.predictPhishingBert(text);
      spamResult = await apiService.predictSpam(text);
      phishingNewResult = await apiService.predictPhishingNew(text);
    } catch (e) {
      print('Error during prediction: $e');
      phishingBertResult = {'error': 'Failed to fetch data'};
      spamResult = {'error': 'Failed to fetch data'};
      phishingNewResult = {'error': 'Failed to fetch data'};
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitLink() {
    final link = _linkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a link.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResponseSafeScreen(
          link: link,
          message: 'This is a safe link', // Replace with actual analysis result
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle between Link and Text Analysis using SegmentedButton
            Theme(
              data: Theme.of(context).copyWith(
                segmentedButtonTheme: SegmentedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.yellow; // Selected segment color
                        }
                        return Colors.transparent; // Unselected segment color (default)
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.black; // Text color for selected segment
                        }
                        return Theme.of(context).colorScheme.onSurface; // Default text color
                      },
                    ),
                  ),
                ),
              ),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Link')),
                  ButtonSegment(value: false, label: Text('Text')),
                ],
                selected: {_isLinkAnalysis},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isLinkAnalysis = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Link Analysis Section (Centered)
            if (_isLinkAnalysis) ...[
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _linkController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the link here',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitLink,
                      child: const Text('Analyse Link'),
                    ),
                  ],
                ),
              ),
            ],

            // Text Analysis Section
            if (!_isLinkAnalysis) ...[
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter text to analyse',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _predictText,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Analyse Text'),
              ),
              const SizedBox(height: 16),
              if (_isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else ...[
                if (phishingBertResult != null) ...[
                  const Text('BERT Phishing Prediction:'),
                  Text('Predicted Class: ${phishingBertResult?['predicted_class'] ?? 'N/A'}'),
                  Text('Confidence Score: ${phishingBertResult?['confidence_score'] ?? 'N/A'}'),
                  const SizedBox(height: 16),
                ],
                if (spamResult != null) ...[
                  const Text('Spam Prediction:'),
                  Text('Predicted Class: ${spamResult?['predicted_class'] ?? 'N/A'}'),
                  Text('Confidence Score: ${spamResult?['confidence_score'] ?? 'N/A'}'),
                  const SizedBox(height: 16),
                ],
                if (phishingNewResult != null) ...[
                  const Text('New Phishing Detection Prediction:'),
                  Text('Predicted Class: ${phishingNewResult?['predicted_class'] ?? 'N/A'}'),
                  Text('Confidence Score: ${phishingNewResult?['confidence_score'] ?? 'N/A'}'),
                  const SizedBox(height: 16),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}