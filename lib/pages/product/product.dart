import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            SizedBox(
                height: 200,
                width: 200,
                child: Image.network(product['productImage'])),
            const SizedBox(height: 20),
            Text(
              product['productName'], style: TextStyle(fontSize: 21),
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            Text(
              '\₹ ${product["productCost"]}',
              style: TextStyle(fontSize: 16),
              // style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 20),
            Text(
              "Seller Number: ${product['sellerNumber']}",
              style: TextStyle(letterSpacing: 1.0),
            ),
            const SizedBox(height: 20),
            Text(product['productDescription']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                buyProduct();
                Navigator.of(context).pop();
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
