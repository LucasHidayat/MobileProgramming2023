import 'package:flutter/material.dart';

import 'package:usedgamesbin/mainScreens/profilescreen.dart';
import 'package:usedgamesbin/mainScreens/registeritem.dart';
import 'package:usedgamesbin/mainScreens/searchscreen.dart';

import 'package:usedgamesbin/models/user.dart';

import 'dart:io';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int index = 0;

  @override
  void initState() {
    super.initState();
    tabchildren = [
      SearchScreen(user: widget.user),
      ItemRegistrationScreen(user: widget.user),
      ProfileScreen(user: widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[index],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: "New Item"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      index = value;
    });
  }
}
