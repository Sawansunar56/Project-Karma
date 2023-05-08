import 'package:flutter/material.dart';
import 'package:karma/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karma/pages/profile.dart';
import 'buy.dart';
import 'sell.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String _userName = '';
  late String _userEmail = '';
  late String _userAddress = '';
  late String _userDescription = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final db = FirebaseFirestore.instance;
    final userDoc = await db.collection('users').doc('userID').get();
    final user = userDoc.data() as Map<String, dynamic>?;

    if (user != null) {
      setState(() {
        _userName = user['name'] ?? '';
        _userEmail = user['email'] ?? '';
        _userAddress = user['address'] ?? '';
        _userDescription = user['description'] ?? '';
      });
    }
  }

  Future<void> _updateUserAddress(String address) async {
    final db = FirebaseFirestore.instance;
    await db.collection('users').doc('userID').update({'address': address});
    setState(() {
      _userAddress = address;
    });
  }

  Future<void> _updateUserDescription(String description) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc('userID')
        .update({'description': description});
    setState(() {
      _userDescription = description;
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KARMA'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_userName),
                    Text(_userEmail),
                    const SizedBox(height: 8),
                    Text('Address: $_userAddress'),
                    const SizedBox(height: 8),
                    Text('Description: $_userDescription'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _userAddress,
                      decoration: InputDecoration(
                        labelText: 'Update Address',
                      ),
                      onFieldSubmitted: (value) {
                        _updateUserAddress(value);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _userDescription,
                      decoration: InputDecoration(
                        labelText: 'Update Description',
                      ),
                      onFieldSubmitted: (value) {
                        _updateUserDescription(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              //  logic for each menu item here
              if (value == 'block') {
                // Code to block user
              } else if (value == 'display_profile') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage())); // Assuming you have a ProfilePage defined
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Update Profile', ''}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase().replaceAll(' ', '_'),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => BuyPage())));
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => SellPage())));
            },
            icon: const Icon(Icons.monetization_on),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'asset/recycle.jpg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to KARMA!',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reduce, Reuse, Recycle',
            ),
            const SizedBox(height: 20),
            const Text(
              'At Karma, we believe that by encouraging the reuse and recycling of products, we can significantly reduce waste and contribute towards building a sustainable future. Our platform allows you to buy and sell products that are reusable and recyclable, ensuring that they do not end up in landfills.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            Image.asset(
              'asset/bottles.png',
              width: MediaQuery.of(context).size.width * 1.0,
            ),
            const SizedBox(height: 20),
            const Text(
              'Benefits of Recycling and Reusing',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reducing and recycling have numerous benefits for the environment and society. They conserve natural resources, reduce energy consumption and greenhouse gas emissions, create jobs, save money, and conserve landfill space. By reducing waste and recycling, we can create a more sustainable future, where resources are conserved and pollution is minimized.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
