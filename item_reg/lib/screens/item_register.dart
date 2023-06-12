import 'package:flutter/material.dart';

import 'package:item_reg/ip_address.dart';

import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ItemRegister extends StatefulWidget {
  const ItemRegister({super.key});

  @override
  State<ItemRegister> createState() => _ItemRegisterState();
}

class _ItemRegisterState extends State<ItemRegister> {
  File? image_cover;
  File? image_1;
  File? image_2;

  var pathAsset = "assets/images/camera.png";

  final formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController latitudeEditingController =
      TextEditingController();
  final TextEditingController longitudeEditingController =
      TextEditingController();
  final TextEditingController countryEditingController =
      TextEditingController();
  final TextEditingController cityEditingController = TextEditingController();

  late Position currentPosition;

  String latitude = "";
  String longitude = "";

  @override
  void initState() {
    super.initState();
    findPosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: const Text("Register Item")),
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            child: Column(children: [
              Flexible(
                  flex: 10,
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Container(
                          height: screenHeight,
                          child: Column(children: [
                            Expanded(
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  validator: (val) =>
                                      val!.isEmpty || (val.length < 3)
                                          ? "Catch name must be longer than 3"
                                          : null,
                                  controller: nameEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Item Name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)))),
                            ),
                            Row(children: [
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current Country"
                                            : null,
                                    enabled: false,
                                    controller: countryEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Country",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    )),
                              ),
                              Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    enabled: false,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current City"
                                            : null,
                                    controller: cityEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "City",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    )),
                              ),
                            ]),
                          ]),
                        ),
                      ))),
              Flexible(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    selectCover();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                    child: Card(
                      child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image_cover == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(image_cover!) as ImageProvider,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    selectImage1();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                    child: Card(
                      child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image_1 == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(image_1!) as ImageProvider,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    selectImage2();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                    child: Card(
                      child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image_2 == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(image_2!) as ImageProvider,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text(
                  "Register",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  registerItem();
                  //registerUser();
                },
              ),
            ]),
          ),
        ));
  }

// send data
  void registerItem() {
    String base64ImageCover = base64Encode(image_cover!.readAsBytesSync());
    String base64Image1 = base64Encode(image_1!.readAsBytesSync());
    String base64Image2 = base64Encode(image_2!.readAsBytesSync());

    http.post(Uri.parse("${MyConfig().SERVER}/item_reg/php/register_item.php"),
        body: {
          "iten_name": nameEditingController.text,
          "latitude": latitude,
          "longitude": longitude,
          "country": nameEditingController.text,
          "city": nameEditingController.text,
          "image_cover": base64ImageCover,
          "image_1": base64Image1,
          "image_2": base64Image2
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void findPosition() async {
    // check Permissions
    if (await Permission.location.request().isGranted) {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }
      currentPosition = await Geolocator.getCurrentPosition();

      getAddress(currentPosition);
    }
  }

// Find Location
  getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      countryEditingController.text = "Malaysia";
      cityEditingController.text = "Changlun";
      latitude = "6.4318";
      longitude = "100.4300";
    } else {
      countryEditingController.text = placemarks[0].country.toString();
      cityEditingController.text = placemarks[0].locality.toString();
      latitude = currentPosition.latitude.toString();
      longitude = currentPosition.longitude.toString();
    }
    setState(() {});
  }

// Select Images
// =================================================================================================
  Future<void> selectCover() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      image_cover = File(pickedFile.path);
      setState(() {});
    }
  }

  Future<void> selectImage1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      image_1 = File(pickedFile.path);
      setState(() {});
    }
  }

  Future<void> selectImage2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      image_2 = File(pickedFile.path);
      setState(() {});
    }
  }
}
