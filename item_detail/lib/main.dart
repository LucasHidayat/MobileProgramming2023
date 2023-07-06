import 'package:flutter/material.dart';

import 'package:item_detail/screens/mainscreen.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  runApp(const MyApp());

  HttpOverrides.global = MyHttpOverrides();
  // runApp(const ConsultationApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Details',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const Scaffold(body: MainScreen()),
    );
  }
}
