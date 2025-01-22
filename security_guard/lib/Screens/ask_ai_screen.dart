import 'package:flutter/material.dart';
import 'package:capstone_proj/services/gemini_service.dart'; // Import the Gemini service

class AskAIScreen extends StatelessWidget {
  final Function(String) onAIMessageGenerated; // Callback for AI-generated messages

  const AskAIScreen({super.key, required this.onAIMessageGenerated});

  @override
  Widget build(BuildContext context) {
    String question = '';

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Ask AI Chatbot!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                ),
              ),
            ),
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (newText) {
              question = newText;
            },
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () async {
              if (question.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a question.')),
                );
                return;
              }

              try {
                // Generate AI response using GeminiService
                final geminiService = GeminiService();
                final aiResponse = await geminiService.generateResponse(question);

                // Pass the AI response back to the chat screen
                onAIMessageGenerated(aiResponse);

                // Close the modal
                Navigator.pop(context);
              } catch (e) {
                print("Error generating AI response: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to generate AI response.')),
                );
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star),
                Text('Generate'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}