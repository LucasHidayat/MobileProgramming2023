import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:usedgamesbin/models/ip_address.dart';
import 'package:usedgamesbin/models/user.dart';

import 'dart:io';

class ItemRegistrationScreen extends StatefulWidget {
  final User user;
  const ItemRegistrationScreen({super.key, required this.user});

  @override
  State<ItemRegistrationScreen> createState() => _ItemRegistrationScreenState();
}

class _ItemRegistrationScreenState extends State<ItemRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: const Text("Register Items")),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(children: [
                SizedBox(
                    height: screenHeight * 0.8,
                    width: screenWidth * 0.5,
                    child: Image.asset(
                      "assets/images/register.jpg",
                      fit: BoxFit.cover,
                    )),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: nameController,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "name must be longer than 3"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: priceController,
                          validator: (val) =>
                              val!.isEmpty ? "enter a valid price" : null,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'price',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: descController,
                          validator: (val) =>
                              val!.isEmpty ? "enter valid description" : null,
                          decoration: const InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                          height: 36,
                          child: Expanded(
                              child: ElevatedButton(
                                  onPressed: onRegisterDialog,
                                  child: const Text("Register Item")))),
                    ],
                  ),
                ),
              ])),
        ));
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      clearText();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerItem();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
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

  void registerItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registering..."),
        );
      },
    );
    String name = nameController.text;
    String price = priceController.text;
    String desc = descController.text;

    Navigator.pop(context);

    http.post(
        Uri.parse("${MyConfig().SERVER}/usedgamesbin/php/register_item.php"),
        body: {
          "name": name,
          "price": price,
          "description": desc,
          "otp": widget.user.otp,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
          // Navigator.pop(context);
          clearText();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
          // Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        // Navigator.pop(context);
      }
    });
  }

  void clearText() {
    nameController.clear();
    priceController.clear();
    descController.clear();
  }
}
