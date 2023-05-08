import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone No.',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String? userId = FirebaseAuth.instance.currentUser!
                  .phoneNumber; // Get the current user IDUE0Un9y0sQTqBAYzxCF9
              FirebaseDatabase database = FirebaseDatabase.instance;
              DatabaseReference ref = database.reference();
              ref.child('users').set({
                'name': nameController.text,
                'address': addressController.text,
                'phone': phoneController.text,
                'description': descriptionController.text,
              }).then((value) {
                // Data saved successfully
              }).catchError((error) {
                // An error occurred while saving the data
              });
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
