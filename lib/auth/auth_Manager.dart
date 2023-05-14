import 'package:flutter/material.dart';
import '../pages/mainpage.dart';
import 'auth.dart';
import 'auth_Page.dart';

class AuthManager extends StatefulWidget {
  static const routeName = '/authManager';
  const AuthManager({Key? key}) : super(key: key);

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainPage();
        } else {
          return AuthPage();
        }
      },
    );
  }
}
