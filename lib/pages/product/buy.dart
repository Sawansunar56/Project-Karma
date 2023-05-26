import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karma/pages/product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyPage extends StatefulWidget {
  BuyPage({Key? key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  getCrate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList("cartProducts"));
  }

  Stream<QuerySnapshot> getDataStream() {
    final String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    return FirebaseFirestore.instance
        .collection('products')
        .where("sellerId", isNotEqualTo: userId)
        .where("status", isEqualTo: "available")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Products'),
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
              return ListTile(
                title: Text("${product['productName']}"),
                subtitle: Text("${product['productDescription']}"),
                trailing: Text('${product['productCost']}'),
                onTap: () {
                  // navigate to product details page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => ProductDetailsPage(
                          product: product, productId: productId)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: getCrate, child: Icon(Icons.abc)),
    );
  }
}
