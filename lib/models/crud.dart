import 'dart:async';
import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CrudMethods {
  CrudMethods ( { this.userId } );
  final String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  getFriends(String uid) async {
    return await Firestore.instance.collection('users').document(uid).collection('friends').getDocuments();
  }
  getFriendRequests(String uid) async {
    print("here");
    DatabaseService DBS = new DatabaseService(uid: uid);
    return await DBS.findFriendRequests();
  }
}