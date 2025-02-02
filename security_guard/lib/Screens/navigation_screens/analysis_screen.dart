import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:provider/provider.dart';
import 'package:capstone_proj/providers/auth_provider.dart'; // Import the AuthProvider
import 'package:capstone_proj/services/scan_service.dart'; // Import the ScanService
import 'dart:convert'; // For jsonEncode

class AnalysisScreen extends StatefulWidget {
  final String? initialText;
  final String? initialLink;

  const AnalysisScreen({super.key, this.initialText, this.initialLink});

  // Constructor for text analysis
  AnalysisScreen.withText({super.key, required String initialText})
      : initialText = initialText,
        initialLink = null;

  // Constructor for link analysis
  AnalysisScreen.withLink({super.key, required String initialLink})
      : initialLink = initialLink,
        initialText = null;

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  Map<String, dynamic>? phishingBertResult;
  Map<String, dynamic>? spamResult;
  Map<String, dynamic>? phishingNewResult;
  Map<String, dynamic>? phishingLogisticResult;
  Map<String, dynamic>? averageResult;

  bool _isLoading = false;
  bool _isLinkAnalysis = true; // Toggle between link and text analysis

  @override
  void initState() {
    super.initState();
    // Pre-fill the text or link if provided
    if (widget.initialText != null) {
      _textController.text = widget.initialText!;
      _isLinkAnalysis = false;
    } else if (widget.initialLink != null) {
      _linkController.text = widget.initialLink!;
      _isLinkAnalysis = true;
    }

    // Automatically trigger analysis if initial text or link is provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialText != null) {
        _predictText();
      } else if (widget.initialLink != null) {
        _predictLink();
      }
    });

    // Fetch user data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.fetchUserData();
    });
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
      phishingLogisticResult = null;
      averageResult = null;
    });

    try {
      // Get the current user's data
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userData = authProvider.userData;
      final username = userData?["userName"] ?? "Guest"; // Use "Guest" if not authenticated

      // Call the API to scan the link
      final result = await ScanService.scanLink(link, username);

      // Log the entire backend response for debugging
      debugPrint('Backend Response: ${jsonEncode(result)}');

      // Parse the results
      setState(() {
        phishingBertResult = result['results']['phishingBert'];
        spamResult = result['results']['spam'];
        phishingNewResult = result['results']['phishingNew'];
        phishingLogisticResult = result['results']['phishingLogistic'];
        averageResult = {
          'predictedClass': result['status'] == 'danger' ? 1 : 0,
          'confidenceScore': result['confidence'],
        };
      });

      // Log the parsed results for debugging
      debugPrint('Parsed Results:');
      debugPrint('phishingBertResult: $phishingBertResult');
      debugPrint('spamResult: $spamResult');
      debugPrint('phishingNewResult: $phishingNewResult');
      debugPrint('phishingLogisticResult: $phishingLogisticResult');
      debugPrint('averageResult: $averageResult');
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

  Future<void> _predictText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      phishingBertResult = null;
      spamResult = null;
      phishingNewResult = null;
      phishingLogisticResult = null;
      averageResult = null;
    });

    try {
      // Get the current user's data
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userData = authProvider.userData;
      final username = userData?["userName"] ?? "Guest"; // Use "Guest" if not authenticated

      // Call the API to scan the text
      final result = await ScanService.scanText(text, username);

      // Log the entire backend response for debugging
      debugPrint('Backend Response: ${jsonEncode(result)}');

      // Parse the results
      setState(() {
        phishingBertResult = result['results']['phishingBert'];
        spamResult = result['results']['spam'];
        phishingNewResult = result['results']['phishingNew'];
        phishingLogisticResult = result['results']['phishingLogistic'];
        averageResult = {
          'predictedClass': result['status'] == 'danger' ? 1 : 0,
          'confidenceScore': result['confidence'],
        };
      });

      // Log the parsed results for debugging
      debugPrint('Parsed Results:');
      debugPrint('phishingBertResult: $phishingBertResult');
      debugPrint('spamResult: $spamResult');
      debugPrint('phishingNewResult: $phishingNewResult');
      debugPrint('phishingLogisticResult: $phishingLogisticResult');
      debugPrint('averageResult: $averageResult');
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
      phishingLogisticResult = null;
      averageResult = null;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  // Build the status banner
  Widget _buildStatusBanner(String status, double confidence) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String statusText;

    switch (status) {
      case "safe":
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        icon = Icons.check_circle;
        statusText = "SAFE";
        break;
      case "danger":
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.warning;
        statusText = "DANGER";
        break;
      default:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        icon = Icons.error;
        statusText = "AMBIGUOUS";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: textColor),
          const SizedBox(height: 10),
          Text(
            "Analysis has finished!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Confidence score: ${confidence.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            status == "safe"
                ? "The content is safe."
                : status == "danger"
                    ? "This content is dangerous!"
                    : "This content is ambiguous.",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Always be cautious when dealing with unknown content.",
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // Build a result card for individual models
  Widget _buildResultCard({required String title, required Map<String, dynamic> result}) {
    final predictedClass = result['predictedClass']?.toString() ?? 'N/A';
    final confidenceScore = result['confidenceScore']?.toString() ?? 'N/A';
    final isPhishing = predictedClass == '1';

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
                          return Theme.of(context).colorScheme.primary; // Use primary color for selected segment
                        }
                        return Colors.transparent; // Unselected segment color (default)
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.onPrimary; // Text color for selected segment
                        }
                        return Theme.of(context).colorScheme.onSurface; // Default text color
                      },
                    ),
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                        return BorderSide(
                          color: Theme.of(context).colorScheme.primary, // Border color for segments
                          width: 1.0,
                        );
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

            // Text Analysis Section (Centered)
            if (!_isLinkAnalysis) ...[
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the text here',
                        ),
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _predictText,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Analyse Text'),
                    ),
                  ],
                ),
              ),
            ],

            // Display Results
            if (_isLoading) ...[
              const Center(),
            ] else ...[
              if (phishingBertResult != null || spamResult != null || phishingNewResult != null || phishingLogisticResult != null || averageResult != null) ...[
                const SizedBox(height: 20),
                // Status Banner
                _buildStatusBanner(
                  averageResult?['predictedClass'] == 1 ? "danger" : "safe",
                  averageResult?['confidenceScore'] ?? 0.0,
                ),
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
              if (phishingLogisticResult != null) ...[
                _buildResultCard(
                  title: 'Logistic Regression Phishing Prediction',
                  result: phishingLogisticResult!,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}