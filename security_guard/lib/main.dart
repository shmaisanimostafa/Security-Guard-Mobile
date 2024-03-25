import 'package:capstone_proj/screens/navigation_screens/chat.dart';
import 'package:capstone_proj/screens/navigation_screens/file.dart';
import 'package:capstone_proj/screens/navigation_screens/home.dart';
import 'package:capstone_proj/screens/navigation_screens/link.dart';
import 'package:capstone_proj/screens/profile.dart';
import 'package:capstone_proj/screens/registration_screens/register.dart';
import 'package:flutter/material.dart';
import 'package:capstone_proj/screens/scan.dart';

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
  ThemeMode? currentThemeMode = ThemeMode.system;
  List<Widget> screens = [
    const Home(),
    const Link(),
    const File(),
    const Chat(),
  ];

  void setCurrentPageIndex(int index) {
    currentPageIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          title: const Text('Security Guard'),
          actions: [
            IconButton(
              icon: const Badge(
                key: Key('notification_badge'),
                child: Icon(Icons.notifications),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const RegisterScreen();
                  }),
                );
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
            TextButton(
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
                padding:
                    const EdgeInsets.all(13), // Adjust the padding as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Profile();
                  }),
                );
              },
              child: const CircleAvatar(
                radius: 15.0,
                backgroundImage: AssetImage('images/ProfilePic.png'),
              ),
            ),
          ],
        ),
        drawer: Drawer(
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
                  setState(() {
                    currentThemeMode = value;
                  });
                }),
          ),
        ),
        //
        // The Scan button which opens the Camera
        //
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton: currentPageIndex == 3
            ? null
            : FloatingActionButton(
                shape: const CircleBorder(),
                child: const Icon(Icons.document_scanner),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const Scan();
                    }),
                  );
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
    );
  }
}
