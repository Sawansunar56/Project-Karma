import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String productId;

  const ProductDetailsPage(
      {Key? key, required this.product, required this.productId})
      : super(key: key);

  buyProduct() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    final productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({"buyerId": userId, "status": "waiting"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image.network(product['imageUrl']),
            const SizedBox(height: 20),
            Text(
              product['productName'],
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product['productCost']}',
              // style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 20),
            Text(product['sellerId']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                buyProduct();
              },
              // add product to cart
              child: Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}
