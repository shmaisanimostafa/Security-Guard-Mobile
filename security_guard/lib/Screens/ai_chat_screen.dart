import 'package:capstone_proj/models/messages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AskAIScreen extends StatelessWidget {
  const AskAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String question = '';
    // return Container(
    // color: const Color(0xff757575),
    // child:
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
              // color: Colors.lightBlueAccent,
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  // color: Colors.lightBlueAccent,
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
                Provider.of<Messages>(context, listen: false)
                    .addMessageAI(question);
              } on Exception catch (e) {
                debugPrint(e.toString());
              }

              Navigator.pop(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star),
                Text(
                  'Generate',
                ),
              ],
            ),
          ),
        ],
      ),
      // ),
    );
  }
}
