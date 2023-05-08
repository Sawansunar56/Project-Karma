import 'package:flutter/material.dart';
import 'package:karma/common/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:karma/pages/buy.dart';
import 'package:karma/pages/mainpage.dart';
// import 'package:karma/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karma',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(),
    );
  }
}
