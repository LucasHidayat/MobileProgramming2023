import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:usedgamesbin/loginScreens/loginscreen.dart';

import 'package:usedgamesbin/models/user.dart';

import 'package:usedgamesbin/models/ip_address.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController changePassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(
          child: SingleChildScrollView(
              child: Column(children: [
            SizedBox(
                height: 400,
                width: 400,
                child: Image.asset(
                  "assets/images/profile.png",
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 10),
            Text(
              widget.user.name.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              widget.user.email.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                    onPressed: passDialogue,
                    child: const Text("Change Password")),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
                height: 36,
                child: Expanded(
                    child: ElevatedButton(
                        onPressed: logoutUser, child: const Text("Log out")))),
          ])),
        ));
  }

  void passDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Update Pass?",
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: changePassController,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String pass = changePassController.text;
                  changePass(pass);
                  Navigator.of(context).pop();
                },
                child: const Text("Change"))
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

  void changePass(String pass) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/usedgamesbin/php/change_pass.php"),
        body: {
          "password": pass,
          "otp": widget.user.otp,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
      }
    });
  }

  void logoutUser() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
