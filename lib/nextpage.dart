import 'package:flutter/material.dart';
import 'package:karma/common/customBtn.dart';

class NextPage extends StatefulWidget {
  static const routeName = '/nextpage';
  const NextPage({Key? key}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int _counter = 0;

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
              'KARMA is a BITCH',
              style: TextStyle(
                color: Colors.red,
                fontSize: 50,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
