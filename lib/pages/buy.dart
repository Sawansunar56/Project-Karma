import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karma/pages/product.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                  print(product);
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
