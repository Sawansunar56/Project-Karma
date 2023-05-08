import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomBtn ({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      child: Text(text),
      onPressed:onPressed ,
      style: ElevatedButton.styleFrom(
          primary:Colors.blue
      ),
    );
  }
}