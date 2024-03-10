import 'package:capstone_proj/Screens/file.dart';
import 'package:capstone_proj/Screens/home.dart';
import 'package:capstone_proj/Screens/link.dart';
import 'package:capstone_proj/Screens/profile.dart';
import 'package:capstone_proj/Screens/scan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;
  int currentThemeMode = 0;
  List<Widget> screens = [
    const Home(),
    const Link(),
    const File(),
    const Profile(),
    const Scan(),
  ];
  List<ThemeMode> screenThemeMode = [
    ThemeMode.dark,
    ThemeMode.light,
    ThemeMode.system
  ];

  void setCurrentPageIndex(int index) {
    currentPageIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //
      // Them mode: Light, Dark, System
      //
      themeMode: screenThemeMode[currentThemeMode],
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.antaTextTheme(
          Theme.of(context).textTheme,

          // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow),
        ),
      ),
      theme: ThemeData(
        textTheme: GoogleFonts.antaTextTheme(
          Theme.of(context).textTheme,
        ),
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
                setState(() {
                  currentThemeMode = 1;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                setState(() {
                  currentThemeMode = 2;
                });
              },
            ),
          ],
        ),
        drawer: const Drawer(
          child: Profile(),
        ),
        //
        // The Scan button which opens the Camera
        //
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.document_scanner),
          onPressed: () {
            setState(() {});
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
              label: 'Profile',
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
