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
                  child: const Icon(Icons.notifications_none_outlined),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 9,
                  child: Center(
                    child: DropdownMenu(
                      enableSearch: false,
                      helperText: 'Select a theme mode',
                      label: const Text('Theme Mode'),
                      dropdownMenuEntries: const <DropdownMenuEntry<ThemeMode>>[
                        DropdownMenuEntry(
                          value: ThemeMode.light,
                          label: 'Light',
                        ),
                        DropdownMenuEntry(
                          value: ThemeMode.dark,
                          label: 'Dark',
                        ),
                        DropdownMenuEntry(
                          value: ThemeMode.system,
                          label: 'System',
                        ),
                      ],
                      onSelected: (value) {
                        setState(
                          () {
                            currentThemeMode = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text('Developed by Mostafa Shmaisani'),
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
