import 'package:flutter/material.dart';

import 'package:item_reg/screens/item_list.dart';
import 'package:item_reg/screens/item_register.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
      const ItemList(),
      const ItemRegister(),
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
                  Icons.notes,
                ),
                label: "List"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.note_add,
                ),
                label: "Register"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      index = value;
    });
  }
}
