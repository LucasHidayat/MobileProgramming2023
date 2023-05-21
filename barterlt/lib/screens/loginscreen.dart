import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:barterlt/models/user.dart';
import 'package:barterlt/screens/mainscreen.dart';
import 'package:barterlt/screens/registrationscreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
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
                Row(children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      remeberMe(value!);
                      setState(() {
                        _isChecked = value;
                      });
                    },
                  ),
                  const Text("Remember me")
                ]),
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

  void goRegister() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void goMain() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const MainScreen()));
  }

  void loginUser() {
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

    http.post(Uri.parse("https://10.19.77.237/barterlt/php/login_user.php"),
        body: {
          "name": name,
          "password": pass,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
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

  void remeberMe(bool value) async {
    String name = nameController.text;
    String password = passController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('name', name);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      await prefs.setString('name', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        nameController.text = '';
        passController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = (prefs.getString('name')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        nameController.text = name;
        passController.text = password;
      });
    }
  }
}
