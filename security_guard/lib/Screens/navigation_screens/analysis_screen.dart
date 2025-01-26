import 'package:capstone_proj/services/scan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
// import 'package:security_guard/services/scan_service.dart'; // Import the ScanService

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
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
      phishingBertResult = null;
      spamResult = null;
      phishingNewResult = null;
    });

    try {
      final text = _textController.text;
      // Call the API to analyze text (replace with actual API call if available)
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      phishingBertResult = {'predicted_class': 1, 'confidence_score': 0.85};
      spamResult = {'predicted_class': 0, 'confidence_score': 0.92};
      phishingNewResult = {'predicted_class': 1, 'confidence_score': 0.78};
    } catch (e) {
      debugPrint('Error during prediction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch data. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _predictLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a link.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      phishingBertResult = null;
      spamResult = null;
      phishingNewResult = null;
    });

    try {
      // Call the API to scan the link
      final result = await ScanService.scanLink(link, "user1"); // Replace "user1" with actual username
      setState(() {
        phishingBertResult = {
          'predicted_class': result['status'] == 'danger' ? 1 : 0,
          'confidence_score': result['confidence'],
        };
      });
    } catch (e) {
      debugPrint('Error during prediction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch data. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearInput() {
    setState(() {
      _textController.clear();
      _linkController.clear();
      phishingBertResult = null;
      spamResult = null;
      phishingNewResult = null;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
        actions: [
          IconButton(
            onPressed: _clearInput,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
          ),
        ],
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
                      onPressed: _isLoading ? null : _predictLink,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Analyse Link'),
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
            ],

            // Display Results
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              if (phishingBertResult != null || spamResult != null || phishingNewResult != null) ...[
                const SizedBox(height: 20),
                const Text(
                  'Analysis Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
              if (phishingBertResult != null) ...[
                _buildResultCard(
                  title: 'BERT Phishing Prediction',
                  result: phishingBertResult!,
                ),
              ],
              if (spamResult != null) ...[
                _buildResultCard(
                  title: 'Spam Prediction',
                  result: spamResult!,
                ),
              ],
              if (phishingNewResult != null) ...[
                _buildResultCard(
                  title: 'New Phishing Detection Prediction',
                  result: phishingNewResult!,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({required String title, required Map<String, dynamic> result}) {
    final predictedClass = result['predicted_class'] ?? 'N/A';
    final confidenceScore = result['confidence_score'] ?? 'N/A';
    final isPhishing = predictedClass == 1;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          ListTile(
            title: Text('Predicted Class: $predictedClass'),
            trailing: Icon(
              isPhishing ? Icons.warning : Icons.check_circle,
              color: isPhishing ? Colors.red : Colors.green,
            ),
          ),
          ListTile(
            title: Text('Confidence Score: $confidenceScore'),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard('$title\nPredicted Class: $predictedClass\nConfidence Score: $confidenceScore'),
            ),
          ),
        ],
      ),
    );
  }
}