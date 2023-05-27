import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductEditPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String uid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  ProductEditPage({Key? key, required this.product, required this.uid})
      : super(key: key);

  updateProduct() async {
    await FirebaseFirestore.instance.collection('products').doc(uid).update({
      'productName': _nameController.text,
      'productCost': _costController.text,
      'productDescription': _descriptionController.text,
    });
  }

  deleteProduct() async {
    await FirebaseFirestore.instance.collection('products').doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child: Image.network(product['productImage'])),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController..text = product['productName'],
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Product Name"),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: _costController..text = product['productCost'],
                decoration: InputDecoration(
                    labelText: "Product Cost", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(
                controller: _descriptionController
                  ..text = product['productDescription'],
                decoration: InputDecoration(
                    labelText: "Product Description",
                    border: OutlineInputBorder())),
            const SizedBox(height: 20),
            Text("Status: ${product['status']}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await updateProduct();
                navigator.pop();
              },
              // add product to cart
              child: Text('Update Product'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await deleteProduct();
                navigator.pop();
              },
              // add product to cart
              child: Text('Delete Product'),
            ),
          ],
        ),
      ),
    );
  }
}
