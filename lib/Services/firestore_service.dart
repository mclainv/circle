import 'package:circle_app_alpha/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  Future createUser(User user) async {
    try {
      await Firestore.instance.collection("users")
          .document(user.id)
          .setData(user
          .toJson());
    } catch (e) {
      return e.message;
    }
  }
  Future getUser(String uid) async {
    try {
      var userData = await
      _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
        return e.message;
    }
  }

}