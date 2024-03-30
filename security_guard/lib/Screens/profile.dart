import 'package:capstone_proj/screens/registration_screens/change_password.dart';

import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const top = 150.0 - 50;
    return MaterialApp(
      // TODO Theme shall be the same as the parent, to be edited later
      // themeMode: ThemeMode.system,
      // darkTheme: ThemeData.dark().copyWith(
      //   textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
      // ),
      // theme: ThemeData(
      //   textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
      //   // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow),
      // ), // Shall be the same as the parent, to be edited later
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      color: Colors.grey[300],
                      child: Image.asset(
                        'images/ProfilePic.png',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                      top: top,
                      left: 10.0,
                      child: CircleAvatar(
                          radius: 50,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage("images/ProfilePic.png"),
                          )),
                    ),
                    Positioned(
                      top: 150.0,
                      left: 150.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mostafa Shmaisani',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Icon(Icons.verified, color: Colors.blue.shade700)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Profile Picture

                const SizedBox(height: 10),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        // title: Text(
                        //   'Mostafa Shmaisani',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20),
                        // ),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const ChangePasswordScreen();
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                        ],
                      ),
                      const SizedBox(height: 10),
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
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 52, 38, 255),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Text('Shmaisanimostafa'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Twitter: ',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Text('Shmaisanimostafa'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Github: ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Text('Shmaisanimostafa'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Mestadon: ',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Text('Shmaisanimostafa'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Instagram: ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
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
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                    child: const Text('Log Out')),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
