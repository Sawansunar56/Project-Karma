import 'package:flutter/material.dart';

import 'package:karma/auth/auth_Manager.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    // ignore: prefer_const_constructors
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthManager()));
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
              // Colors.purple,
              //  Colors.black
              Theme.of(context).colorScheme.primary.withOpacity(0.5),
              Theme.of(context).colorScheme.secondary,
            ])),
        child: Center(
          child: Container(
              child: const Text(
            'KARMA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // color: Colors.white,
            ),
          )),
        ),
      ),
    );
  }
}
