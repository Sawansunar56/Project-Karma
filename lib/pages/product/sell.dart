import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karma/pages/product/add_product.dart';
import 'package:karma/pages/product/product_edit.dart';

class SellPage extends StatefulWidget {
  SellPage({Key? key}) : super(key: key);

  @override
  _SellPage createState() => _SellPage();
}

class _SellPage extends State<SellPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Only produces a snapshot of the products that have the current users id.
  Stream<QuerySnapshot> getDataStream() {
    final User? user = auth.currentUser;
    return FirebaseFirestore.instance
        .collection('products')
        .where("sellerId", isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Products'),
      ),
      body: StreamBuilder(
        stream: getDataStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final productId = products[index].reference.id;
              print(products);

              return ListTile(
                title: Text("${product['productName']}"),
                subtitle: Text("${product['productDescription']}"),
                trailing: Text('${product['productCost']}'),
                onTap: () {
                  // navigate to product details page
                  print(product);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) =>
                          ProductEditPage(product: product, uid: productId)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddProductPage()));
        },
        child: const Icon(Icons.monetization_on),
      ),
    );
  }
}
