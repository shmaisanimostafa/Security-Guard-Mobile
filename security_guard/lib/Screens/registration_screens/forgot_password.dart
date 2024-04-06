import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Enter your email address to reset your password',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement your password reset logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const EnterCodeScreen();
                  }),
                );
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Enter the verification code sent to your email',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement your code verification logic here
              },
              child: const Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}
