import 'dart:async';

import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Models/relationship.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:circle_app_alpha/Services/StandardServices/firestore_service.dart';
import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';

class FriendService {
  final FirestoreService _firestoreService =
  locator<FirestoreService>();
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();

  final CollectionReference _relationshipCollectionReference =
  Firestore.instance.collection('relationships');
  final CollectionReference _profilesCollectionReference =
  Firestore.instance.collection('profiles');

  final StreamController<List<Friend>> _friendsController =
  StreamController<List<Friend>>.broadcast();
//  final StreamController<List<Friend>> _friendRequestsController =
//  StreamController<List<Friend>>.broadcast();


  Stream listenToFriendsRealTime(String username) {
    var friends;
    _relationshipCollectionReference.snapshots().listen((relationshipsSnapshot) {
      if (relationshipsSnapshot.documents.isNotEmpty) {
        var relationships = relationshipsSnapshot.documents
            .where((mappedItem) => mappedItem.data['hetaera'] == username
            || mappedItem.data['sappho'] == username) //Might be able to shorten this code piece
            .map((snapshot) => Relationship.fromMap(snapshot.data, snapshot.documentID))
            .toList();
        // Add the friends onto the controller
        _friendsController.add(friends);
      }
    });

    return _friendsController.stream;
  }

  Future getProfileOfFriend(Relationship relationship, String username) async {
    _profilesCollectionReference.snapshots().listen((profilesSnapshot) {
      var profiles;
      profiles += profilesSnapshot.documents.where((mappedItem) =>
      mappedItem[relationship.getUsernameOfFriend(username)]);
      return profiles;
    });
  }
//  listenToFriendRequestsRealTime(String username) {
//    _friendRequestsCollectionReference.snapshots().listen((friendRequestsSnapshot) {
//      if (friendRequestsSnapshot.documents.isNotEmpty) {
//        var friendRequest = friendRequestsSnapshot.documents
//            .where((mappedItem) => mappedItem.data['sentToUsername'] == username)
//            .map((snapshot) => Friend.fromMap(snapshot.data, snapshot.documentID))
//            .where((mappedItem) => mappedItem.name != null)
//            .toList();
//        // Add the friendRequests onto the controller
//        _friendRequestsController.add(friendRequest);
//      }
//    });
//
//    return _friendRequestsController.stream;
//  }


}