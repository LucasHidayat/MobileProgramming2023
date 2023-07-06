import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:item_detail/ip_address.dart';

class ItemDetail extends StatefulWidget {
  final Map itemDetails;
  const ItemDetail({super.key, required this.itemDetails});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
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
                        "${MyConfig().SERVER}/item_detail/assets/items/${widget.itemDetails['id']}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Text(widget.itemDetails['name']),
                  Text("Price : RM ${widget.itemDetails['price'].toString()}"),
                  Text(widget.itemDetails['desc'])
                ],
              ),
            ),
          ),
        ));
  }
}
