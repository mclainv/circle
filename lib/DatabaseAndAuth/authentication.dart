import 'dart:async';
import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
import 'package:circle_app_alpha/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);

  Future<User> signUp(String email, String password, String username);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  static bool _usernameTaken;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map
      (_userFromFirebaseUser);
  }
  DatabaseService _databaseService;

  //create user obj based on Firebase User
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
  //creates user obj based on Firebase User and a username
  User _userFromFirebaseUsername(FirebaseUser user, String username) {
    return user != null ? User(uid: user.uid, username: username) : null;
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


  Future<User> signUp(String email, String password, String username) async {
    //sets up async function
    //check if the username is taken
    var usernameCheck = await DatabaseService().checkUsername(username);
    if(usernameCheck == 0) {
      try {
        AuthResult result = await
        _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        //creates a custom user file
        await _databaseService.createUser(User(
            uid: result.user.uid,
            username: username,
            email: email));
        //creates result object of type AuthResult. Waits to receive firebaseAuth request before setting user and returning the uid.
        FirebaseUser user = result.user;
        //Returns the user object and the username
        return _userFromFirebaseUsername(user, username);
      }
      catch(e) { print(e); }
    }
    else {
      // "Username taken. Please choose another.";
      _usernameTaken = true;
      throw new Exception('This username is already in use.');
    }
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
