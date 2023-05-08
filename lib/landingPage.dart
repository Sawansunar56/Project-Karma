import 'package:flutter/material.dart';
import 'package:karma/common/customBtn.dart';
import 'package:karma/nextpage.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/LandingPage';
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _counter = 0;

  void navigateToNextPage(BuildContext context) {
    Navigator.pushNamed(context, NextPage.routeName);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'KARMA',
              style: TextStyle(
                color: Colors.red,
                fontSize: 50,
              ),
            ),
            SizedBox(
              child: CustomBtn(
                onPressed: () => navigateToNextPage(context),
                text: 'vhj ',
              ),
            ),
            TextButton(
                onPressed: () => navigateToNextPage(context),
                child: (Text('gcdvj')))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
