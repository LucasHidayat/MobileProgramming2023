import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:item_reg/models/items.dart';
import 'package:http/http.dart' as http;
import 'package:item_reg/ip_address.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<Items> itemList = <Items>[];
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth == 1;
        },
        child: itemList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : Column(children: [
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(
                          itemList.length,
                          (index) {
                            return Card(
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/mynelayan/assets/catches/${itemList[index].id}_cover.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].name.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "Country: ${itemList[index].country}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "City: ${itemList[index].city}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]),
                            );
                          },
                        )))
              ]),
      ),
    );
  }

  void loadItems() {
    http.post(Uri.parse("${MyConfig().SERVER}/item_reg/php/load_item.php"),
        body: {}).then((response) {
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Items.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }
}
