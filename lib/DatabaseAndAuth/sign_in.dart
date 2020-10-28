import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
import 'package:circle_app_alpha/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoogleSignIn googleSignIn = GoogleSignIn();
User _userFromFirebaseUser(FirebaseUser user) {
  return user != null ? User(id: user.uid) : null;
}
Future<User> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;


  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);

  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);

  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();

  assert(user.uid == currentUser.uid);

  return _userFromFirebaseUser(user);
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
