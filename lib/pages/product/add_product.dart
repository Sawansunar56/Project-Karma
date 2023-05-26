import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
  }

  Future<void> addProduct() async {
    final User? user = auth.currentUser;
    await FirebaseFirestore.instance.collection('products').add({
      'sellerId': user?.uid,
      'buyerId': "unknown",
      'status': 'available',
      'productName': _nameController.text,
      'productCost': _costController.text,
      'productDescription': _descriptionController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
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
              height: 80,
            ),
            ElevatedButton(
                onPressed: () {
                  addProduct();
                  Navigator.of(context).pop();
                },
                child: Text("Add Product"))
          ],
        ),
      ),
    );
  }
}
