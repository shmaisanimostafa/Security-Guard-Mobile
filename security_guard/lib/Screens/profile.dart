import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_proj/models/auth_provider.dart'; // Import AuthProvider
import 'package:capstone_proj/Screens/registration_screens/change_password.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Fetch user data if it's not already loaded
          if (authProvider.userData == null) {
            authProvider.fetchUserData();
            return Center(child: CircularProgressIndicator()); // Show a loader while fetching data
          }

          final userData = authProvider.userData;

          return SingleChildScrollView(
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
                      Positioned(
                        top: 100.0, // Adjust based on the height of your image
                        left: 10.0,
                        child: CircleAvatar(
                          radius: 50,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: userData?['imageURL'] != null
                                ? NetworkImage(userData!['imageURL'])
                                : AssetImage("images/ProfilePic.png") as ImageProvider,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 160.0,
                        left: 130.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${userData?['firstName']} ${userData?['lastName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.verified, color: Colors.blue.shade700)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('@${userData?['userName']}'),
                              Text('${userData?['email']}'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FilledButton(
                              child: const Text('Edit Account'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ChangePasswordScreen(); // Update with actual edit screen
                                    },
                                  ),
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
                              Text('7/2/2002'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FilledButton(
                              child: const Text('Edit Profile'),
                              onPressed: () {
                                // Implement edit profile functionality
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
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Shmaisanimostafa'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Mastodon: ',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              child: const Text('Edit Connections'),
                              onPressed: () {
                                // Implement edit connections functionality
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Log Out Button
                  FilledButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      authProvider.logout(); // Call logout method
                      Navigator.popUntil(context, ModalRoute.withName('/')); // Navigate to initial route
                    },
                    child: const Text('Log Out'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
