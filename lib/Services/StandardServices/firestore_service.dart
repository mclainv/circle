import 'dart:async';

import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Models/friend_request.dart';
import 'package:circle_app_alpha/Models/relationship.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _friendRequestsCollectionReference =
      Firestore.instance.collection('friendRequests');



  Future createUser(User user) async {
    try {
      await Firestore.instance.collection("users")
          .document(user.id)
          .setData(user
          .toJson());
    } catch (e) {
      return e;
    }
  }
  Future createFriendRequest(FriendRequest friendRequest) async {
    try {
      await _friendRequestsCollectionReference.add(friendRequest.toJson());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }
  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      return e;
    }
  }
}