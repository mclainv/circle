import 'dart:async';
import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
import 'package:circle_app_alpha/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);

  Future signUpWithEmail(String email, String password, String username);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<bool> isUserLoggedIn();
}

class Auth implements BaseAuth {

  User _currentUser;

  User get currentUser => _currentUser;

  static bool _usernameTaken;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map
      (_userFromFirebaseUser);
  }

  DatabaseService _databaseService;

  //create user obj based on Firebase User
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  //creates user obj based on Firebase User and a username
  User _userFromFirebaseUsername(FirebaseUser user, String username) {
    return user != null ? User(id: user.uid, username: username) : null;
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
    String uidA = await user.uid;
    print("$uidA");
    String username = await DatabaseService(uid: uidA).findUsername();
    return _userFromFirebaseUsername(user, username);
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _databaseService.getUser(user.uid);
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
      await _databaseService.createUser(_currentUser);

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
      await _populateCurrentUser(authResult.user); // Populate the user information
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user); // Populate the user information
    return user != null;
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
