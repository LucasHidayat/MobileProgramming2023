import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:usedgamesbin/models/ip_address.dart';
import 'package:usedgamesbin/models/user.dart';

import 'package:usedgamesbin/mainScreens/detailsscreen.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'dart:io';

class SearchScreen extends StatefulWidget {
  final User user;
  const SearchScreen({super.key, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchList = [];
  late double screenWidth;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Search Screen"), actions: [
        IconButton(
            onPressed: () {
              searchDialogue();
            },
            icon: const Icon(Icons.search)),
      ]),
      body: Center(
          child: searchList.isEmpty
              ? const Text("Enter Search Term")
              : ListView.builder(
                  padding: const EdgeInsets.all(30),
                  itemCount: searchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: EdgeInsets.all(20),
                        height: 72,
                        color: Colors.lightGreen,
                        child: Expanded(
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  searchList[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                child: const Text("Details"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                              itemDetail: searchList[index],
                                              user: widget.user,
                                            )),
                                  );
                                },
                              ),
                            ],
                          ),
                        ));
                  })),
    );
  }

  void searchDialogue() {
    print(searchList.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Search?",
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItems(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void searchItems(String search) {
    try {
      http.post(
          Uri.parse("${MyConfig().SERVER}/usedgamesbin/php/search_item.php"),
          body: {"search": search}).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            searchList = jsondata['data'];
            print('display search');
            print(searchList);
            setState(() {
              searchList = jsondata['data'];
            });
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
