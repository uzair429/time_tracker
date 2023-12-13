import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('WELCOME',style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,

        ),),
      ),
    );
  }
}
