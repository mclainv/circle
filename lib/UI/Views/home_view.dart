import 'package:flutter/material.dart';
import 'package:circle_app_alpha/Models/user.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key, User user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Welcome"), Text(user.username),
          ],
        ),
      )
    );
  }
}