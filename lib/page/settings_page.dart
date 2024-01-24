import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String language = 'Portugese';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title:const Text("Change settings")),
    body: const Text('There will be settings!'));
  void changeLanguage(dynamic) {}
}
