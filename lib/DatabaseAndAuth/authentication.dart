import 'dart:async';
import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
import 'package:circle_app_alpha/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);

  Future signUpWithEmail(String email, String password, String username);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<bool> isUserLoggedIn();

  // ignore: non_constant_identifier_names
  Future<User> populateCurrentUser(FirebaseUser user);
}

class Auth implements BaseAuth {

  User _currentUser;

  User get currentUser => _currentUser;
  // ignore: non_constant_identifier_names
  static bool _usernameTaken = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<Future> get user {
    return _firebaseAuth.onAuthStateChanged.map
    //needs to return a User from a firebase user
      (_userFromFirebaseUser);
  }

  DatabaseService _databaseService;

  //create user obj based on Firebase User
  Future<User> _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? DatabaseService.getUser(user.uid) : null;

  }

  //returns whether or not the username is taken (the boolean value)
  bool getUserTaken() {
    return _usernameTaken;
  }

  //Signs in the user with their email and password, returns a custom User object based on firebase's return
  Future<User> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return DatabaseService.getUser(user.uid.toString());
  }

  Future<User> populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      User customUser = await DatabaseService.getUser(user.uid);
      print(customUser.getUsername());
      return customUser;
    }
  }

//  Future<User> signUp(String email, String password, String username) async {
//    //sets up async function
//    //check if the username is taken
//    var usernameCheck = await DatabaseService().checkUsername(username);
//    if(usernameCheck == 0) {
//      try {
//        AuthResult result = await
//        _firebaseAuth.createUserWithEmailAndPassword(
//            email: email, password: password);
//        //creates a custom user file
//        await _databaseService.createUser(User(
//            id: result.user.uid,
//            username: username,
//            email: email));
//        return result.user != null;
//        //creates result object of type AuthResult. Waits to receive firebaseAuth request before setting user and returning the uid.
//        //Returns the user object and the username
//      }
//      catch(e) { print(e); }
//    }
//    else {
//      // "Username taken. Please choose another.";
//      _usernameTaken = true;
//      throw new Exception('This username is already in use.');
//    }
//  }
  Future signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // create a new user profile on firestore
      _currentUser = User(
        id: authResult.user.uid,
        email: email,
      );
      await DatabaseService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await populateCurrentUser(authResult.user); // Populate the user information
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await populateCurrentUser(user); // Populate the user information
    if(user != null)
    return true;
        return false;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
