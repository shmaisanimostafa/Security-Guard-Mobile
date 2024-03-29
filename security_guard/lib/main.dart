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
        // routes: {
        //   '/home': (context) => const Home(),
        //   '/link': (context) => const Link(),
        //   '/file': (context) => const File(),
        //   '/profile': (context) => const Profile(),
        //   '/scan': (context) => const Scan(),
        // },
        //
        // Them mode: Light, Dark, System
        //
        themeMode: currentThemeMode,
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
                // Image.asset(
                //   'images/LogoMini.png',
                //   fit: BoxFit.contain,
                //   height: 32,
                // ),
                Icon(
                  Icons.military_tech_sharp,
                  color: Color(0xFFFFD700),
                  size: 32,
                ),
                SizedBox(width: 10),
                Text('Security Guard'),
              ],
            ),
            actions: [
              IconButton(
                icon: Badge(
                  isLabelVisible: isNotified,
                  child: const Icon(Icons.notifications),
                ),
                onPressed: () {
                  setState(() {
                    isNotified = !isNotified;
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) {
                  //     return const RegisterScreen();
                  //   }),
                  // );
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.more_vert),
              //   onPressed: () {
              //     setState(() {
              //       currentThemeMode = 2;
              //     });
              //   },
              // ),
              isSignedIn
                  ? TextButton(
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(
                            13), // Adjust the padding as needed
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
                  child: const Icon(Icons.document_scanner),
                  onPressed: () {
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
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.link),
                label: 'Link',
              ),
              NavigationDestination(
                icon: Icon(Icons.file_open),
                label: 'File',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat),
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
