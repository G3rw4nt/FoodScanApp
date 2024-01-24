import 'package:flutter/material.dart';
import 'package:foodscanner/page/add_page.dart';
import 'package:foodscanner/page/browse_page.dart';
import 'package:foodscanner/page/scan_page.dart';
import 'package:foodscanner/page/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  final screens = [
    const AddPage(),
    const ScanPage(),
    const BrowsePage(),
    const SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline), label: 'Add'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.barcode_reader), label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder_open_outlined), label: 'Browse'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ]),
      ),
    );
  }
}
