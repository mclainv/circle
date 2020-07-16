import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  //Collection reference
  final CollectionReference usersCollection = Firestore.instance.collection(
      'users');
  final CollectionReference usernamesCollection = Firestore.instance.collection(
      'usernames');
  final CollectionReference friendsCollection = Firestore.instance.collection(
      'friends');
  final CollectionReference friendRequestsCollection = Firestore.instance
      .collection('friendRequests');

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendFriendRequest(String myUsername,
      String otherUsername) async {
    if (isLoggedIn()) {
      var usernameCheck = await DatabaseService().checkUsername(otherUsername);
      if (usernameCheck > 0) {
        friendRequestsCollection.add({
          'from': myUsername,
          'to': otherUsername
        }).catchError((e) {
          print(e);
        });
      }
      else {
        print('This user does not exist.');
        throw new Exception('This user does not exist.');
      }
    } else {
      print('You need to be logged in.');
      throw new Exception('You need to be logged in.');
    }
  }

  Future getFriendRequests(String username) async {
    return friendRequestsCollection.where("username", isEqualTo: username)
        .snapshots()
        .listen(
            (data) => print('grower ${data.documents[0]['uid']}')
    );
  }

  Future updateBasicUserData(String username, Map friends, Map circles,
      double balance) async {
    return await usersCollection.document(uid).setData({
      'username': username,
      'friends': friends,
      'circles': circles,
      'balance': balance,
    });
  }

  Future addUsername(String username, String uid) async {
    return await usernamesCollection.document(uid).setData({
      'username': username
    });
  }

  Future checkUsername(String username) async {
    final result = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    print(result.documents.length);
    print(username);
    return result.documents.length;
  }
  getUserDocuments() async {
    return await Firestore.instance.collection('users').getDocuments();
  }

  Future findUsername() async {
    getUserDocuments().then((val) {
      //Ensure documents exist
      if (val.documents.length > 0) {
        //Run through all documents
        for(int i = 0; i < val.documents.length; i++) {
          //If the current user ID equals the real user ID,
          if(val.documents[i].documentID == this.uid) {
            //return this username
            return (val.documents[i].data["username"]);
          }
        }
      }
      else {
        print("Not Found");
        return null;
      }
    });
  }
}