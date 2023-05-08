import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('gs://karma-bbf57.appspot.com/')
            .snapshots(),
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
              return ListTile(
                title: Text('$products[' 'name' ']'),
                subtitle: Text('$product[' 'description' ']'),
                trailing: Text('${product['price']}'),
                onTap: () {
                  // navigate to product details page
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
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(product['imageUrl']),
          const SizedBox(height: 20),
          Text(
            product['name'],
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 10),
          Text(
            '\$${product['price']}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 20),
          Text(product['description']),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // add product to cart
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
