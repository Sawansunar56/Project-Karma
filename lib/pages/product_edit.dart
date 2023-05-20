import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductEditPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String uid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  ProductEditPage({Key? key, required this.product, required this.uid})
      : super(key: key);

  updateProduct() async {
    await FirebaseFirestore.instance.collection('products').doc(uid).update({
      'Product Name': _nameController.text,
      'Cost': _costController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['Product Name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image.network(product['imageUrl']),
          const SizedBox(height: 20),
          TextField(
              controller: _nameController..text = product['Product Name']),
          const SizedBox(height: 10),
          TextField(controller: _costController..text = product['Cost']
              // style: Theme.of(context).textTheme.subtitle1,
              ),
          const SizedBox(height: 20),
          Text(product['userId']),
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
        ],
      ),
    );
  }
}
