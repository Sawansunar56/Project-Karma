import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String productId;

  const ProductDetailsPage(
      {Key? key, required this.product, required this.productId})
      : super(key: key);

  buyProduct() async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('productSnapshot')
        .doc(productId)
        .get();
    if (productSnapshot.exists) {
      final product = productSnapshot.data() as Map<String, dynamic>;
    }
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
