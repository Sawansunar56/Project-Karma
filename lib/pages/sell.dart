import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karma/pages/product.dart';

class SellPage extends StatefulWidget {
  SellPage({Key? key}) : super(key: key);

  @override
  _SellPage createState() => _SellPage();
}

class _SellPage extends State<SellPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addProduct() async {
    final User? user = auth.currentUser;
    await FirebaseFirestore.instance.collection('products').add({
      'userId': user?.uid,
      'Product Name': 'I have ',
      'Cost': '20000',
    });
  }

  // Only produces a snapshot of the products that have the current users id.
  Stream<QuerySnapshot> getDataStream() {
    final User? user = auth.currentUser;
    return FirebaseFirestore.instance
        .collection('products')
        .where("userId", isEqualTo: user?.uid)
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
              final User? user = auth.currentUser;
              final product = products[index].data() as Map<String, dynamic>;
              print(products);

              return ListTile(
                title: Text("${product['Cost']}"),
                subtitle: Text("${product['Product Name']}"),
                trailing: Text('${product['userId']}'),
                onTap: () {
                  // navigate to product details page
                  print(product);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) =>
                          ProductDetailsPage(product: product)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.monetization_on),
      ),
    );
  }
}
