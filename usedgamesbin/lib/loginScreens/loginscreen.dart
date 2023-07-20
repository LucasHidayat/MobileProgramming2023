import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:usedgamesbin/models/ip_address.dart';

import 'package:usedgamesbin/models/user.dart';
import 'package:usedgamesbin/mainScreens/mainscreen.dart';
import 'package:usedgamesbin/loginScreens/registrationscreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  late User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login User")),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                    height: 36,
                    child: Expanded(
                        child: ElevatedButton(
                            onPressed: loginUser, child: const Text("Login")))),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: goRegister,
                  child: const Text(
                    "Need to Register? Press here",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ])),
        ));
  }

  void loginUser() async {
    print("potato");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Loging in..."),
        );
      },
    );
    String name = nameController.text;
    String pass = passController.text;

    Navigator.pop(context);

    http.post(Uri.parse("${MyConfig().SERVER}/usedgamesbin/php/login_user.php"),
        body: {
          "name": name,
          "password": pass,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Success")));
          goMain();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Failed")));
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login Failed")));
        Navigator.pop(context);
      }
    });
  }

  void goRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void goMain() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => MainScreen(user: user)));
  }
}
