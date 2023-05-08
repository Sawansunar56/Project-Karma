import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  final VoidCallback showLoginPage;
  const Register({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController phNumberController = TextEditingController();
  // final TextEditingController lnameController = TextEditingController();
  // final TextEditingController unameController = TextEditingController();

  static const Color firstColor = Color(0xFF703EFE);
  static const Color secondColor = Color(0xFF0A0057);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // fullnameController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    try {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // After successful sign up
        // Navigator.pushReplacementNamed(context, '/create_profile');
        addUserDetails(
            fullnameController.text.trim(), phNumberController.text.trim());
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('  Password Not Matched'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password is Week, Choose Stronger one'),
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    'Oops ! Account for this email already exits, please LOGIN instead'),
              );
            });
      }
    }
  }

  Future addUserDetails(String fullName, String phoneNumber) async {
    await FirebaseFirestore.instance.collection('users').add({
      'fullname': fullName,
      'phoneNumber': phoneNumber,
    });
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() == confirmpassController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.5),
              Theme.of(context).colorScheme.secondary.withOpacity(.9),
            ])),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // const SizedBox(
            //   height: 100,
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: const [
                  Text(
                    'Thanks !\nfor choosing us',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text(
                  //   'We are happy that you choose us',
                  //   style: TextStyle(color: Colors.white, fontSize: 20),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 30.0),
            TextFormField(
              controller: fullnameController,
              decoration: const InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                // Regular expression pattern to validate email
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                if (value == null || value.isEmpty) {
                  return 'Please enter an email address';
                }
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: phNumberController,
              // obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmpassController,
              // obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),

            const SizedBox(height: 30.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already a Member?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: const Text(
                    '  Login Instead',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 50,
            ),

            GestureDetector(
              onTap: signup,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: secondColor.withOpacity(.9),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 50.0,
                // color: Colors.blue,
                child: const Center(
                    child: Text(
                  'LETs Go!',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
