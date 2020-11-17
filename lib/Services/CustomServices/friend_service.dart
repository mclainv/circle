import 'dart:async';

import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Models/relationship.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle_app_alpha/Services/StandardServices/firestore_service.dart';
import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';

class FriendService {
  final FirestoreService _firestoreService =
  locator<FirestoreService>();
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();

  final CollectionReference _relationshipsCollectionReference =
  Firestore.instance.collection('relationships');
  final CollectionReference _profilesCollectionReference =
  Firestore.instance.collection('profiles');

  final StreamController<List<Relationship>> _relationshipsController =
  StreamController<List<Relationship>>.broadcast();

  final StreamController<List<Friend>> _friendsController =
  StreamController<List<Friend>>.broadcast();

  Stream listenToRelationshipsRealTime(String username) {
    print("listen to relationships real time");
    _relationshipsCollectionReference.snapshots().listen((relationshipsSnapshot) {
      if (relationshipsSnapshot.documents.isNotEmpty) {
        var relationships = relationshipsSnapshot.documents
            .where((mappedItem) => mappedItem.data['hetaera'] == username ||
                    mappedItem.data['sappho'] == username)//Might be able to shorten this code piece
            .map((snapshot) => Relationship.fromMap(snapshot.data, username, snapshot.documentID))
            .toList();
        // Add the relationships onto the controller
        _relationshipsController.add(relationships);
      }
    });

    return _relationshipsController.stream;
  }

  Stream listenToProfilesRealTime(List<Relationship> relationships, String username) {
    print("listen to friendships real time");
    List<String> usernames = new List<String>();
    if(relationships != null) {
      for (int i = 0; i < relationships.length; i++) {
        usernames.add(relationships[i].getHetaera());
      }
      _profilesCollectionReference.snapshots().listen((profilesSnapshot) {
        if (profilesSnapshot.documents.isNotEmpty) {
          var friends = profilesSnapshot.documents
              .where((mappedItem) => usernames.contains(mappedItem["username"]))
              .map((snapshot) =>
              Friend.fromMap(snapshot.data, snapshot.documentID))
              .toList();
          //add the friends onto the controller
          _friendsController.add(friends);
          print(friends);
        }
      });
    }
    else {
      print("Did not have relationships to pull profiles of");
    }
      return _friendsController.stream;
  }
}