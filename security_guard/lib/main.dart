import 'package:capstone_proj/constants.dart';
import 'package:capstone_proj/models/messages.dart';
import 'package:capstone_proj/screens/navigation_screens/chat.dart';
import 'package:capstone_proj/screens/navigation_screens/file.dart';
import 'package:capstone_proj/screens/navigation_screens/home.dart';
import 'package:capstone_proj/screens/navigation_screens/link.dart';
import 'package:capstone_proj/screens/profile.dart';
import 'package:capstone_proj/screens/registration_screens/register.dart';
import 'package:flutter/material.dart';
import 'package:capstone_proj/screens/scan.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
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
        // Applying Anta font
        darkTheme: ThemeData.dark().copyWith(
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
        ),
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Anta'),
          // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow),
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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DrawerHeader(
                  child: Text('Security Guard'),
                ),
                Text('Settings', textAlign: TextAlign.center),
                ListTile(
                  title: const Text('Theme Mode'),
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
                                title: const Text('Light'),
                                onTap: () {
                                  setState(() {
                                    currentThemeMode = ThemeMode.light;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Dark'),
                                onTap: () {
                                  setState(() {
                                    currentThemeMode = ThemeMode.dark;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('System'),
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
                  title: const Text('About'),
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
