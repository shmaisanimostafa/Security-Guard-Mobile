import 'package:capstone_proj/Screens/registration_screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_proj/providers/auth_provider.dart';
import 'package:capstone_proj/Screens/registration_screens/change_password.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87, // Consistent with login screen
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.yellow.shade200, Colors.yellow.shade800], // Consistent gradient
          ),
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.userData == null) {
              authProvider.fetchUserData();
              return const Center(child: CircularProgressIndicator());
            }

            final userData = authProvider.userData;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section with Gradient
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black87, Colors.black54], // Dark gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: userData?['imageURL'] != null
                                ? NetworkImage(userData!['imageURL'])
                                : const AssetImage("images/ProfilePic.png") as ImageProvider,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${userData?['firstName']} ${userData?['lastName']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '@${userData?['userName']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Account Information Card
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.email, color: Colors.black87),
                            title: Text('Email'),
                            subtitle: Text('user@example.com'),
                          ),
                          const SizedBox(height: 20),

                          // Grouped Buttons for Change Password and Edit Profile
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChangePasswordScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Change Password',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(userData: userData),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // About Me Card (Coming Soon)
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.info, color: Colors.black87),
                            title: Text('About Me'),
                            subtitle: Text('This feature is coming soon!'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Show a "Coming Soon" message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('About Me feature is coming soon!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Edit About Me',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Connections Card (Coming Soon)
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.link, color: Colors.black87),
                            title: Text('Connections'),
                            subtitle: Text('This feature is coming soon!'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Show a "Coming Soon" message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Connections feature is coming soon!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Edit Connections',
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Log Out Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        authProvider.logout();
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}