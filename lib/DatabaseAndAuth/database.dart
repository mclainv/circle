import 'dart:collection';
import 'package:circle_app_alpha/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class DatabaseService {

  DatabaseService._();

  //Collection reference
  static final CollectionReference _usersCollectionReference = Firestore.instance.collection(
      "users");
  static final CollectionReference usernamesCollection = Firestore.instance.collection(
      'usernames');
  static final CollectionReference friendsCollection = Firestore.instance.collection(
      'friends');
  static final CollectionReference friendRequestsCollection = Firestore.instance
      .collection('friendRequests');

  static bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future createUser(User user) async {
    try {
      await Firestore.instance.collection("users")
          .document(user.id)
          .setData(user
          .toJson());
      } catch (e) {
      return e.message;
    }
  }
  static Future<User> getUser(String uid) async {
    try {
      var userData = await
      Firestore.instance.collection("users").document(uid).get();
        return User.fromData(userData.data);
    } catch (e) {
      if(e != null)
        return e;
    }
  }

  static Future addUsername(String username, String uid) async {
    return await usernamesCollection.document(uid).setData({
      'username': username
    });
  }

  static Future checkUsername(String username) async {
    final result = await Firestore.instance.collection("users").where(
        "username", isEqualTo: username).getDocuments();
    print(result.documents.length);
    print(username);
    return result.documents.length;
  }
  static getUserDocuments() async {
    return await Firestore.instance.collection('users').getDocuments();
  }
  static getFriendRequestDocuments() async {
    return await Firestore.instance.collection('friendRequests').getDocuments();
  }
  static Future getFriendRequests(String username) async {
    return friendRequestsCollection.where("username", isEqualTo: username)
        .snapshots()
        .listen(
            (data) => print('grower ${data.documents[0]['uid']}')
    );
  }

  static Future findUsername(String uid) async {
    getUserDocuments().then((val) {
      //Ensure documents exist
      if (val.documents.length > 0) {
        //Run through all documents
        for(int i = 0; i < val.documents.length; i++) {
          //If the current user ID equals the real user ID,
          if(val.documents[i].documentID == uid) {
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
  static Future findFriendRequests() async {
    List allFriendRequests;
    getFriendRequestDocuments().then((val) {

      //Ensure documents exist
      if (val.documents.length > 0) {
        //Run through all documents
        for(int i = 0; i < val.documents.length; i++) {
          //If the current user ID equals the real user ID, TODO: DOESN'T WORK.. needs to query in real time? Need to step through the code in order to make sense of its failure
          if(val.documents[i].data() == 'testFriend') {
            //return this username
            allFriendRequests += (val.documents[i].data["from"]);
          }
        }
        return allFriendRequests;
      }
      else {
        print("Not Found");
        return null;
      }
    });
  }
  static Future<void> sendFriendRequest(String myUsername,
      String otherUsername) async {
    if (isLoggedIn()) {
      var usernameCheck = await checkUsername(otherUsername);
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
}