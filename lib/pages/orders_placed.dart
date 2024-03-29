import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karma/pages/product/product_orders.dart';

class OrdersPlaced extends StatelessWidget {
  OrdersPlaced({super.key});

  Stream<QuerySnapshot> getDataStream() {
    final String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    return FirebaseFirestore.instance
        .collection('products')
        .where("buyerId", isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders Placed"),
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
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Text(
                      (product["status"] == "waiting")
                          ? "W"
                          : (product["status"] == "ongoing" ? "O" : "C"),
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ),
                ),
                title: Text("${product['productName']}"),
                subtitle: Text("${product['productDescription']}"),
                trailing: Text('${product['productCost']}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ProductOrders(
                            product: product,
                            productId: productId,
                          ))));
                },
              );
            },
          );
        },
      ),
    );
  }
}
