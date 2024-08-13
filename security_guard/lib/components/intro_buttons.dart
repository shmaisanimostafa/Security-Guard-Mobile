import 'package:capstone_proj/Screens/registration_screens/log_in.dart';
import 'package:flutter/material.dart';

class IntroButtons extends StatelessWidget {
  const IntroButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton(onPressed: () {}, child: const Text('Scan File')),
        FilledButton(onPressed: () {}, child: const Text('Scan Link')),
        FilledButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LogInScreen();
            }));
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.teal),
          ),
          child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
