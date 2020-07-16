import 'package:circle_app_alpha/MainPages/set_username_page.dart';
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
  String _userId = "";
  User realUser;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          realUser = _userFromFirebaseUsername(user, "test");
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }
  User _userFromFirebaseUsername(FirebaseUser user, String username) {
    return user != null ? User(uid: user.uid, username: username) : null;
  }
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        realUser = _userFromFirebaseUsername(user, "test");
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
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
        if (_userId.length > 0 && _userId != null) {
          if(DatabaseService(uid: _userId).findUsername == null) {
            return new SetUsernamePage(
              auth: widget.auth,
              loginCallback: loginCallback,
              user: realUser,
              //logoutCallback: logoutCallback,
            );
          }
          else if(DatabaseService(uid: _userId).findUsername != null) {
            return new Dashboard(
              auth: widget.auth,
              thisUser: realUser,
              //logoutCallback: logoutCallback,
            );

          }
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}