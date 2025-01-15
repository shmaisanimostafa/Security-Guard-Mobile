import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_proj/functions/mongo_message_api_handler.dart';

class AskAIScreen extends StatelessWidget {
  const AskAIScreen({super.key});

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
              try {
                // Access MongoMessageAPIHandler via Provider
                final mongoMessageAPIHandler =
                    Provider.of<MongoMessageAPIHandler>(context, listen: false);

                // Call addMongoMessageAI with the question
                await mongoMessageAPIHandler.addMongoMessageAI(question);
              } on Exception catch (e) {
                debugPrint(e.toString());
              }

              Navigator.pop(context);
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