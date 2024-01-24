import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title:const Text("Browse products")),
    body: const Text('There will be product browser!'));
}