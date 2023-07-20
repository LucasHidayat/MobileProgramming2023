import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:usedgamesbin/models/ip_address.dart';

import 'package:usedgamesbin/loginScreens/loginscreen.dart';

import 'dart:io';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: const Text("Register User")),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(children: [
                SizedBox(
                    height: screenHeight * 0.25,
                    width: screenWidth,
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
                          controller: emailController,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: passController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
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
                                  child: const Text("Register")))),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: goLogin,
                        child: const Text(
                          "Already Registered? Login",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
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
            "Register new account?",
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
                registerUser();
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

  void registerUser() {
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
    String email = emailController.text;
    String pass = passController.text;

    Navigator.pop(context);

    http.post(
        Uri.parse("${MyConfig().SERVER}/usedgamesbin/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
          Navigator.pop(context);
          goLogin();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }
    });
  }

  void clearText() {
    nameController.clear();
    emailController.clear();
    passController.clear();
  }

  void goLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
