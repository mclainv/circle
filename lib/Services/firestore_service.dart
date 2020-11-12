import 'dart:async';

import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Models/friend_request.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _circlesCollectionReference =
      Firestore.instance.collection('circles');
  final CollectionReference _friendsCollectionReference =
      Firestore.instance.collection('friends');
  final CollectionReference _friendRequestsCollectionReference =
      Firestore.instance.collection('friendRequests');

  final StreamController<List<Circle>> _circlesController =
  StreamController<List<Circle>>.broadcast();

  final StreamController<List<Friend>> _friendsController =
  StreamController<List<Friend>>.broadcast();

  final StreamController<List<Friend>> _friendRequestsController =
  StreamController<List<Friend>>.broadcast();

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
  Future createCircle(Circle circle) async {
    try {
      await _circlesCollectionReference.add(circle.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

//  Future getCirclesOnceOff() async {
//    try {
//      var postDocumentSnapshot = await _circlesCollectionReference.getDocuments();
//      if (postDocumentSnapshot.documents.isNotEmpty) {
//        return postDocumentSnapshot.documents
//            .map((snapshot) => Circle.fromMap(snapshot.data, snapshot.documentID))
//            .where((mappedItem) => mappedItem.name != null)
//            .toList();
//      }
//    } catch (e) {
//      if (e is PlatformException) {
//        return e.message;
//      }
//
//      return e.toString();
//    }
//  }

  Stream listenToCirclesRealTime(String username) {
    _circlesCollectionReference.snapshots().listen((circlesSnapshot) {
      if (circlesSnapshot.documents.isNotEmpty) {
        var circles = circlesSnapshot.documents
            .where((mappedItem) => mappedItem.data['creatorUser'] == username
              || mappedItem.data['memberUsername'].toString().contains(username))
            .map((snapshot) => Circle.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();

        // Add the posts onto the controller
        _circlesController.add(circles);
      }
    });

    return _circlesController.stream;
  }

  Future deleteCircle(String documentId) async {
    await _circlesCollectionReference.document(documentId).delete();
  }
  Future leaveCircle(Circle circle, User user) async {
    Map removedMap = new Map.from(circle.toMap());
    for(int i = 0; i < removedMap.length; i++) {
      if(removedMap[i].contains(user.id)) {
         removedMap[i] = null;
      }
    }
    await _circlesCollectionReference.document(circle.documentId)
        .updateData(removedMap);
  }

  Future updateCircle(Circle circle) async {
    try {
      await _circlesCollectionReference
          .document(circle.documentId)
          .updateData(circle.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  listenToFriendsRealTime() {
    _friendsCollectionReference.snapshots().listen((friendsSnapshot) {
      if (friendsSnapshot.documents.isNotEmpty) {
        var friends = friendsSnapshot.documents
            //
            .where((mappedItem) => mappedItem.data['username'] == 'this'
            || mappedItem.data['username2'] == 'that') //TODO: check against user's username
            .map((snapshot) => Friend.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
        // Add the friends onto the controller
        _friendsController.add(friends);
      }
    });

    return _friendsController.stream;
  }

  listenToFriendRequestsRealTime(String username) {
    _friendRequestsCollectionReference.snapshots().listen((friendRequestsSnapshot) {
      if (friendRequestsSnapshot.documents.isNotEmpty) {
        var friendRequest = friendRequestsSnapshot.documents
            .where((mappedItem) => mappedItem.data['sentToUsername'] == username)
            .map((snapshot) => Friend.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
        // Add the friendRequests onto the controller
        _friendsController.add(friendRequest);
      }
    });

    return _friendRequestsController.stream;
  }

}