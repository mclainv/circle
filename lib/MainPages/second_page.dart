import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecondScreen extends StatelessWidget {
  @override
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Multi Page Application Page-1"),
      ),
        body: new Checkbox(
            value: false,
            onChanged: (bool newValue) {
              _firebaseAuth.signOut();
              Navigator.of(ctxt).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            }
    )
    );
    }
}