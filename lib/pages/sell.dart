import 'package:flutter/material.dart';

class SellPage extends StatelessWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Products'),
      ),
      body: const Center(
        child: Text(
          'This is the Sell page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.monetization_on),
      ),
    );
  }
}
