import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  saveCartProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("cartProducts", ["Power"]);
  }

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['Product Name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image.network(product['imageUrl']),
          const SizedBox(height: 20),
          Text(
            product['Product Name'],
            // style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 10),
          Text(
            '\$${product['Cost']}',
            // style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 20),
          Text(product['userId']),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveCartProducts,
            // add product to cart
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
