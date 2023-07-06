import 'package:cached_network_image/cached_network_image.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:item_detail/ip_address.dart';
import 'package:item_detail/screens/item_detail.dart';

import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  var itemList = [];
  var searchList = [];
  var displayList = [];
  late double screenHeight, screenWidth;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    loadItems();

    return Scaffold(
        appBar: AppBar(title: const Text("Item List"), actions: [
          IconButton(
              onPressed: () {
                searchDialogue();
              },
              icon: const Icon(Icons.search)),
        ]),
        body: displayList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: displayList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: screenWidth,
                    width: screenWidth,
                    color: Colors.green,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          height: screenWidth - 100,
                          width: screenWidth - 100,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${MyConfig().SERVER}/item_detail/assets/items/${displayList[index]['id']}.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        Text(displayList[index]['name']),
                        Text(
                            "Price : RM ${displayList[index]['price'].toString()}"),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
                                  builder: (context) => ItemDetail(
                                      itemDetails: displayList[index])),
                            );
                          },
                        )
                      ],
                    ),
                  );
                }));
  }

  Future<void> loadItems() async {
    try {
      http.post(Uri.parse("${MyConfig().SERVER}/item_detail/php/load_item.php"),
          body: {}).then((response) {
        //print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            // rawjson.clear();
            // rawjson = jsondata['data'];
            // itemList = rawjson;
            itemList.clear();
            displayList.clear();
            itemList = jsondata['data'];
            displayList = itemList;
            print('display all');
            print(displayList);
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void searchDialogue() {
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
          Uri.parse("${MyConfig().SERVER}/item_detail/php/search_item.php"),
          body: {"search": search}).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            // rawjson.clear();
            // rawjson = jsondata['data'];
            // itemList = rawjson;
            searchList.clear();
            displayList.clear();
            searchList = jsondata['data'];
            displayList = searchList;
            print('display search');
            print(displayList);
            setState(() {});
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
