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

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final productId = products[index].reference.id;

              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 2,
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              child: Image.network(
                            product["productImage"],
                          )),
                        ),
                        SizedBox(height: 10),
                        Text(
                          product["productName"],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          product["productType"],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  // navigate to product details page
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
