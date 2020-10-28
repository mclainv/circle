import 'package:circle_app_alpha/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle_app_alpha/MainPages/login_signup_page.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
import 'package:circle_app_alpha/MainPages/dashboard.dart';

import 'database.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  User user;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUser) {
      DatabaseService.getUser(firebaseUser.uid).then((customUser) {
        setState(() {
          authStatus =
          customUser?.id == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
          });
        });
      });
  }
  void loginCallback() {
    widget.auth.getCurrentUser().then((firebaseuser) {
      setState(() {

      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
          {
            return new Dashboard(
              auth: widget.auth,
              user: user,
              //logoutCallback: logoutCallback,
            );
          }
        break;
      default:
        return buildWaitingScreen();
    }
  }
}