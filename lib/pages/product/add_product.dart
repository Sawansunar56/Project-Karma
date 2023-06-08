import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  final TextEditingController _nameController = TextEditingController(text: "");

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _costController = TextEditingController();

  XFile? image;

  List<String> dropdownItems = ['Plastic Waste', 'Recycle Waste'];

  late String selectedDropdownItem;

  @override
  void initState() {
    super.initState();
    selectedDropdownItem = dropdownItems[0]; // Set the initial selected item
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<List<String>> getUserDetails() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection("users");

    final DocumentSnapshot userSnapshot =
        await usersCollection.doc(userId).get();

    final phoneNumber = userSnapshot.get('phone');
    final address = userSnapshot.get("address");

    return [address, phoneNumber];
  }

  Future<void> addProduct() async {
    String image_url = await uploadImage();
    List<String> userDetails = await getUserDetails();
    await FirebaseFirestore.instance.collection('products').add({
      'sellerId': userId,
      'sellerAddress': userDetails[0],
      'sellerNumber': userDetails[1],
      'buyerId': "unknown",
      'status': 'available',
      'productName': _nameController.text,
      'productCost': _costController.text,
      'productDescription': _descriptionController.text,
      'productImage': image_url,
      'productType': selectedDropdownItem,
    });
  }

  uploadImage() async {
    String image_url = "";
    if (image != null) {
      var imageFile = File(image!.path);

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("Image-" + _nameController.text);

      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        var url = await ref.getDownloadURL();
        image_url = url.toString();
      }).catchError((onError) {
        print(onError);
      });
    }
    return image_url;
  }

  getImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Product Name'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Product Cost'),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product Description'),
            ),
            SizedBox(
              height: 30,
            ),
            DropdownButton<String>(
              value: selectedDropdownItem,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedDropdownItem = newValue;
                  });
                }
              },
              items:
                  dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 80,
            ),
            ElevatedButton(
                onPressed: () {
                  getImage();
                },
                child: Text("pick image")),
            ElevatedButton(
                onPressed: () async {
                  if (image == null) {
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Provide the details first"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"))
                              ],
                            ));
                  } else {
                    addProduct();
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Add Product"))
          ],
        ),
      ),
    );
  }
}
