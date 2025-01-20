import 'package:capstone_proj/models/fast_api_service.dart';
import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  // Default constructor
  const PredictionScreen({super.key, this.initialText});

  // Named constructor with an optional parameter for pre-filled text
  const PredictionScreen.withText({super.key, this.initialText});

  final String? initialText;

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final FastAPIService apiService = FastAPIService('http://localhost:8000');
  final TextEditingController _textController = TextEditingController();

  Map<String, dynamic>? phishingBertResult;
  Map<String, dynamic>? spamResult;
  Map<String, dynamic>? phishingNewResult;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text field if initialText is provided
    if (widget.initialText != null) {
      _textController.text = widget.initialText!;
    }
  }

  Future<void> _predict() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to analyze',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _predict,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Predict'),
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
        ),
      ),
    );
  }
}