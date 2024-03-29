import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestPage extends StatelessWidget {
  RequestPage({super.key});

  Stream<QuerySnapshot> getDataStream() {
    final String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    return FirebaseFirestore.instance
        .collection('products')
        .where("sellerId", isEqualTo: userId)
        .where("status", isNotEqualTo: "available")
        .snapshots();
  }

  Future<void> updateStatus(String productId) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .update({"status": "ongoing"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Request"),
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
                  if (product["status"] == "waiting") {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Do you want to Accept the Order?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      updateStatus(productId);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Yes")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"))
                              ],
                            ));
                  } else if (product["status"] == "ongoing") {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  "Waiting for delivery Confirmation from buyer"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"))
                              ],
                            ));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
