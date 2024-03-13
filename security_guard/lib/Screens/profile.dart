import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
                radius: 50,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage("images/ProfilePic.png"),
                )),
            const SizedBox(height: 10),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    title: Text(
                      'Mostafa Shmaisani',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('@Shmaisanimostafa'),
                        Text('Shmaisanimostafa@gmail.com')
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FilledButton(
                        child: const Text(
                          'Edit Account',
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(height: 10),
                      // const SizedBox(width: 8),
                      // TextButton(
                      //   child: const Text('Sign up'),
                      //   onPressed: () {/* ... */},
                      // ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    title: Text(
                      'About Me',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Computer Science Undergraduate Student'),
                        Text('7/2/2002')
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FilledButton(
                        child: const Text(
                          'Edit Profile',
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(height: 10),
                      // const SizedBox(width: 8),
                      // TextButton(
                      //   child: const Text('Sign up'),
                      //   onPressed: () {/* ... */},
                      // ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    title: Text(
                      'Connections',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Facebook: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Text('Shmaisanimostafa'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Twitter: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Text('Shmaisanimostafa'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FilledButton(
                        child: const Text(
                          'Edit Connections',
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(height: 10),
                      // const SizedBox(width: 8),
                      // TextButton(
                      //   child: const Text('Sign up'),
                      //   onPressed: () {/* ... */},
                      // ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(onPressed: () {}, child: const Text('Log Out')),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
