import 'package:flutter/material.dart';

import 'package:usedgamesbin/models/user.dart';

class DetailsScreen extends StatefulWidget {
  final Map itemDetail;
  final User user;

  const DetailsScreen(
      {super.key, required this.itemDetail, required this.user});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
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
              height: screenWidth - 120,
              width: screenWidth - 120,
              color: Colors.lightGreen,
              child: Column(
                children: [
                  Text(widget.itemDetail['name']),
                  Text("Price : RM ${widget.itemDetail['price'].toString()}"),
                  Text(widget.itemDetail['desc']),
                  widget.user.otp != widget.itemDetail['otp']
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          child: const Text("Purchase"),
                          onPressed: () {},
                        )
                      : const Text(
                          "This product is being sold by you. You cannot purchase this product")
                ],
              ),
            ),
          ),
        ));
  }
}
