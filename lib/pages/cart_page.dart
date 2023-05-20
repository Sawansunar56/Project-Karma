import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getDataStream() {
    final User? user = auth.currentUser;
    return FirebaseFirestore.instance
        .collection('products')
        .where("Product Name", isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Page"),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
              stream: getDataStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Something went Wrong"));
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
                    final product =
                        products[index].data() as Map<String, dynamic>;
                    print(products);

                    return ListTile(
                      title: Text("${product['Cost']}"),
                      subtitle: Text("${product['Product Name']}"),
                      trailing: Text('${product['userId']}'),
                      onTap: () {},
                    );
                  },
                );
              }),
        ),
        ElevatedButton(onPressed: () {}, child: Text("Proceed to Buy")),
      ]),
    );
  }
}
