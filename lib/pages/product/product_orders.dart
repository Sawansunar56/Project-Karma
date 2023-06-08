import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductOrders extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productId;

  const ProductOrders(
      {super.key, required this.product, required this.productId});

  @override
  State<ProductOrders> createState() => _ProductOrdersState();
}

class _ProductOrdersState extends State<ProductOrders> {
  Future<void> receivedProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .update({"status": "completion"});
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Text("Deafult");
    if (widget.product["status"] == "waiting") {
      buttonSection = const ElevatedButton(
          onPressed: null, child: Text("Waiting Confirmation from Seller"));
    } else if (widget.product["status"] == "ongoing") {
      buttonSection = ElevatedButton(
          onPressed: () {
            receivedProduct(widget.productId);
            Navigator.of(context).pop();
          },
          child: Text("Got the Product"));
    } else if (widget.product["status"] == "completion") {
      buttonSection =
          ElevatedButton(onPressed: null, child: Text("Order Completed"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child: Image.network(widget.product['productImage'])),
            const SizedBox(height: 20),
            Text(
              widget.product['productName'], style: TextStyle(fontSize: 21),
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            Text(
              '\₹ ${widget.product["productCost"]}',
              style: TextStyle(fontSize: 16),
              // style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 20),
            Text(
              widget.product['sellerNumber'],
              style: TextStyle(letterSpacing: 1.6),
            ),
            const SizedBox(height: 20),
            Text(
              "Status: ${widget.product['status']}",
              style: TextStyle(letterSpacing: 1.6),
            ),
            const SizedBox(height: 20),
            Text(
              "Type: ${widget.product['productType']}",
              style: TextStyle(letterSpacing: 1.6),
            ),
            const SizedBox(height: 20),
            Text(
              "Address: ${widget.product['sellerAddress']}",
              style: TextStyle(letterSpacing: 1.2),
            ),
            const SizedBox(height: 20),
            Text(widget.product['productDescription']),
            const SizedBox(height: 20),
            buttonSection,
          ],
        ),
      ),
    );
  }
}
