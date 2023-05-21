import 'package:flutter/material.dart';

import 'package:barterlt/screens/loginscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int index = 0;
  String maintitle = "Account";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      SizedBox(
          height: 36,
          child: Expanded(
              child: ElevatedButton(
                  onPressed: logoutUser, child: const Text("Log out")))),
      const Text("Items"),
      const Text("Search"),
      const Text("Message"),
      const Text("Rate")
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
                  Icons.person,
                ),
                label: "Account"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shop,
                ),
                label: "Items"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: "Message"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.star,
                ),
                label: "Rate")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      index = value;
      if (index == 0) {
        maintitle = "Account";
      }
      if (index == 1) {
        maintitle = "Items";
      }
      if (index == 2) {
        maintitle = "Search";
      }
      if (index == 3) {
        maintitle = "Message";
      }
      if (index == 4) {
        maintitle = "Rate";
      }
    });
  }

  void logoutUser() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
