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
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity, // Ensure container fills width
        height: double.infinity, // Ensure container fills height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.yellow.shade200, Colors.yellow.shade800], // Yellow gradient
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
                  // Profile Header Section with Image
                  Container(
                    alignment: Alignment.center,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: userData?['imageURL'] != null
                                ? NetworkImage(userData!['imageURL'])
                                : const AssetImage("images/ProfilePic.png") as ImageProvider,
                          ),
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
                  const SizedBox(height: 30),

                  // Grouped Buttons for Change Password and Edit Profile
                  Column(
                    children: [
                      // Change Password Button
                      Container(
                        width: 250, // Set a smaller width for the button
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(color: Colors.yellow, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Edit Profile Button
                      Container(
                        width: 250, // Set a smaller width for the button
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.yellow, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Log Out Button with Confirmation
                  Container(
                    width: 250, // Set a smaller width for the button
                    child: ElevatedButton(
                      onPressed: () async {
                        bool confirmLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Log Out'),
                                ),
                              ],
                            );
                          },
                        ) ?? false;

                        if (confirmLogout) {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          authProvider.logout();
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
