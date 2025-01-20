import 'package:capstone_proj/Screens/mongo_message_screen.dart';
import 'package:capstone_proj/Screens/prediction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:capstone_proj/Screens/scan.dart';
import 'package:capstone_proj/Screens/registration_screens/register.dart';
import 'package:capstone_proj/Screens/navigation_screens/file.dart';
import 'package:capstone_proj/Screens/navigation_screens/home.dart';
import 'package:capstone_proj/Screens/navigation_screens/link.dart';
import 'package:capstone_proj/Screens/profile.dart';
import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/providers/auth_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// Top-level function for writing feedback screenshot to storage
Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;
  bool isNotified = true;
  ThemeMode? currentThemeMode = ThemeMode.system;
  List<Widget> screens = [
    const Home(),
    const Link(),
    const UploadFileScreen(),
    MongoChatScreen(),
    PredictionScreen(),
  ];

  // Navigation Icons
  Icon homeIcon = kHomeFilled;
  Icon linkIcon = kLinkOut;
  Icon scanIcon = kScanOut;
  Icon chatIcon = kChatOut;
  Icon fileIcon = kFileOut;
  Icon notificationIcon = kNotificationFilled;

  // Color Scheme
  bool isColored = false;
  MaterialColor schemeColor = Colors.amber;

  void resetIcons(int index) {
    homeIcon = kHomeOut;
    linkIcon = kLinkOut;
    scanIcon = kScanOut;
    chatIcon = kChatOut;
    fileIcon = kFileOut;
    if (index == 0) {
      homeIcon = kHomeFilled;
    } else if (index == 1) {
      linkIcon = kLinkFilled;
    } else if (index == 2) {
      fileIcon = kFileFilled;
    } else if (index == 3) {
      chatIcon = kChatFilled;
    } else {
      scanIcon = kScanFilled;
    }
  }

  void setCurrentPageIndex(int index) {
    setState(() {
      currentPageIndex = index;
      resetIcons(index);
    });
  }

  void submitFeedback(BuildContext context) async {
    try {
      BetterFeedback.of(context).show((feedback) async {
        // Draft an email and send to the developer
        final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

        final Email email = Email(
          body: feedback.text,
          subject: 'App Feedback',
          recipients: ['shmaisanimostafa@gmail.com'],
          attachmentPaths: [screenshotFilePath],
          isHTML: false,
        );
        await FlutterEmailSender.send(email);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Ensure user data is fetched
    if (authProvider.isAuthenticated && authProvider.userData == null) {
      authProvider.fetchUserData();
    }

    return MaterialApp(
      themeMode: currentThemeMode,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: isColored
            ? ColorScheme.dark().copyWith(primary: schemeColor)
            : null,
      ),
      theme: ThemeData(
        colorScheme: isColored
            ? ColorScheme.fromSwatch(primarySwatch: schemeColor)
            : null,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: const Row(
            children: [
              SizedBox(width: 10),
              Text('Security Guard'),
            ],
          ),
          actions: [
            authProvider.isAuthenticated
                ? Builder(
                    builder: (context) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(13),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Profile()),
                          );
                        },
                        child: FutureBuilder<String>(
                          future: authProvider.fetchProfileImageUrl(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                              return const Icon(Icons.error);
                            } else {
                              return CircleAvatar(
                                radius: 12.0,
                                backgroundImage: NetworkImage(snapshot.data!),
                              );
                            }
                          },
                        ),
                      );
                    },
                  )
                : Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  'Security Guard',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Text('Settings', textAlign: TextAlign.center),
              const Divider(),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.dark_mode_outlined),
                    SizedBox(width: 10),
                    Text('Theme Mode'),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select a theme mode'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.wb_sunny_outlined),
                                  SizedBox(width: 10),
                                  Text('Light Mode'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  currentThemeMode = ThemeMode.light;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.nightlight_round),
                                  SizedBox(width: 10),
                                  Text('Dark Mode'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  currentThemeMode = ThemeMode.dark;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.auto_awesome_mosaic_outlined),
                                  SizedBox(width: 10),
                                  Text('System Mode'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  currentThemeMode = ThemeMode.system;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.color_lens_outlined),
                    SizedBox(width: 10),
                    Text('Color Scheme'),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select a color'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.color_lens, color: Colors.amber),
                                  SizedBox(width: 10),
                                  Text('Amber'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  isColored = true;
                                  schemeColor = Colors.amber;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.color_lens, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text('Blue'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  isColored = true;
                                  schemeColor = Colors.blue;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.color_lens, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Red'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  isColored = true;
                                  schemeColor = Colors.red;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.color_lens, color: Colors.green),
                                  SizedBox(width: 10),
                                  Text('Green'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  isColored = true;
                                  schemeColor = Colors.green;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Row(
                                children: [
                                  Icon(Icons.color_lens, color: Colors.deepPurple),
                                  SizedBox(width: 10),
                                  Text('Purple'),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  isColored = true;
                                  schemeColor = Colors.deepPurple;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Default'),
                              onTap: () {
                                setState(() {
                                  isColored = false;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(),
              const Text('Others', textAlign: TextAlign.center),
              const Divider(),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.bug_report_outlined),
                    SizedBox(width: 10),
                    Text('Feedback'),
                  ],
                ),
                onTap: () {
                  submitFeedback(context);
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text('About'),
                  ],
                ),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Security Guard',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Image(
                      image: AssetImage('images/Logo.png'),
                      width: 50,
                      height: 50,
                    ),
                    applicationLegalese:
                        '© ${DateTime.now().year} Mostafa Shmaisani',
                  );
                },
              ),
              const Divider(),
              const Text(
                'Developed by Mostafa Shmaisani',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: currentPageIndex == 3
            ? null
            : FloatingActionButton(
                shape: const CircleBorder(),
                child: scanIcon,
                onPressed: () {
                  setState(() {
                    resetIcons(4);
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Theme(
                              data: Theme.of(context).copyWith(),
                              child: const Scan())));
                },
              ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
              icon: homeIcon,
              label: 'Home',
            ),
            NavigationDestination(
              icon: linkIcon,
              label: 'Link',
            ),
            NavigationDestination(
              icon: fileIcon,
              label: 'File',
            ),
            NavigationDestination(
              icon: chatIcon,
              label: 'Chat',
            ),
            NavigationDestination(
              icon: fileIcon,
              label: 'Prediction',
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setCurrentPageIndex(index);
          },
        ),
        body: screens[currentPageIndex],
      ),
    );
  }
}