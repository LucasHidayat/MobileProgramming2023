import 'package:flutter/material.dart';

import 'package:usedgamesbin/loginScreens/loginscreen.dart';

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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UsedGamesBin',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const Scaffold(body: LoginScreen()),
    );
  }
}
