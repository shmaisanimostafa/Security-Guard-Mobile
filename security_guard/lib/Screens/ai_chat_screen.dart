import 'package:flutter/material.dart';

class AskAIScreen extends StatelessWidget {
  const AskAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // String newTaskTitle = '';
    return Container(
      // color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          // color: Colors.white,
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
                // newTaskTitle = newText;
              },
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Provider.of<TaskData>(context, listen: false)
                //     .addTask(newTaskTitle);
                Navigator.pop(context);
              },
              // style: ButtonStyle(
              //   backgroundColor:
              //       MaterialStateProperty.all(Colors.lightBlueAccent),
              // ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star),
                  Text(
                    'Generate',
                    // style: TextStyle(
                    //   color: Colors.white,
                    // ),
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
