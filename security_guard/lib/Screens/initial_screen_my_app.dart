import 'package:capstone_proj/Screens/registration_screens/register.dart';
import 'package:capstone_proj/Screens/navigation_screens/chat.dart';
import 'package:capstone_proj/Screens/navigation_screens/file.dart';
import 'package:capstone_proj/Screens/navigation_screens/home.dart';
import 'package:capstone_proj/Screens/navigation_screens/link.dart';
import 'package:capstone_proj/Screens/profile.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:capstone_proj/models/messages.dart';
import 'package:capstone_proj/Screens/scan.dart';
import 'package:capstone_proj/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;
  bool isSignedIn = false;
  bool isNotified = true;
  ThemeMode? currentThemeMode = ThemeMode.system;
  List<Widget> screens = [
    const Home(),
    const Link(),
    const UploadFileScreen(),
    const Chat(),
  ];
//
// Navigation Icons
//
  Icon homeIcon = kHomeFilled;
  Icon linkIcon = kLinkOut;
  Icon scanIcon = kScanOut;
  Icon chatIcon = kChatOut;
  Icon fileIcon = kFileOut;
  Icon notificationIcon = kNotificationFilled;

//
// Color Scheme
//
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
    currentPageIndex = index;
  }

  void submitFeedback(BuildContext context) async {
    try {
      BetterFeedback.of(context).show((feedback) async {
        // draft an email and send to developer
        final screenshotFilePath =
            await writeImageToStorage(feedback.screenshot);

        final Email email = Email(
          body: feedback.text,
          subject: 'App Feedback',
          recipients: ['shmaisanimostafa@gmail.com'],
          attachmentPaths: [screenshotFilePath],
          isHTML: false,
        );
        // debugPrint(feedback.text);
        await FlutterEmailSender.send(email);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Messages>(create: (context) => Messages()),
        Provider<bool>.value(value: isSignedIn),
      ],
      child: MaterialApp(
        //
        // Them mode: Light, Dark, System
        //
        themeMode: currentThemeMode,
        // darkTheme: ThemeData.dark.copyWith(
        // Applying Anta font
        darkTheme: ThemeData.dark().copyWith(
          // textTheme: 'Anta',
          // textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
          colorScheme: isColored
              ? const ColorScheme.dark().copyWith(primary: schemeColor)
              : null,
        ),
        theme: ThemeData(
          // textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
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
              // IconButton(
              //     onPressed: () {
              //       submitFeedback(context);
              //     },
              //     icon: const Icon(Icons.bug_report_outlined)),
              // IconButton(
              //     onPressed: () {
              //       setState(() {
              //         isColored = !isColored;
              //       });
              //     },
              //     icon: const Icon(Icons.color_lens)),
              IconButton(
                icon: Badge(
                  isLabelVisible: isNotified,
                  child: notificationIcon,
                ),
                onPressed: () {
                  setState(() {
                    isNotified = !isNotified;
                    notificationIcon =
                        isNotified ? kNotificationFilled : kNotificationOut;
                  });
                },
              ),
              isSignedIn
                  ? TextButton(
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(13),
                      ),
                      onPressed: () {
                        setState(() {
                          // isSignedIn = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Profile();
                          }),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 12.0,
                        backgroundImage: AssetImage('images/ProfilePic.png'),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.login),
                      onPressed: () {
                        setState(() {
                          isSignedIn = true;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const RegisterScreen();
                          }),
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
                  // padding: EdgeInsets.all(2),
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
                  // subtitle: const Text("getThemeModeLabel"),
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
                  // subtitle: const Text("getThemeModeLabel"),
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
                                    Icon(Icons.color_lens,
                                        color: Colors.deepPurple),
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
                      // children: const [
                      //   Text('Developed by Mostafa Shmaisani'),
                      // ],
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
          //
          // The Scan button which opens the Camera
          //
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

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
          //
          // The bottom navigation bar
          //
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
            ],

            //
            // The label behavior of the bottom navigation bar
            //
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            //
            // The OnChnage selected index
            //
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
                resetIcons(index);
              });
            },
          ),
          // The body of the app, where the screens changes
          body: screens[currentPageIndex],
        ),
      ),
    );
  }
}
