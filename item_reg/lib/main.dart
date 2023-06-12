import 'package:flutter/material.dart';

import 'package:item_reg/screens/mainscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Reg',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const Scaffold(body: MainScreen()),
    );
  }
}
