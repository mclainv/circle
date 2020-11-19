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

  final CollectionReference _profilesCollectionReference =
  Firestore.instance.collection('profiles');

  final StreamController<List<Friend>> _friendsController =
  StreamController<List<Friend>>.broadcast();

  Stream listenToProfilesRealTime(String username) {
    print("listen to friend profiles real time");
    _profilesCollectionReference.snapshots().listen((profilesSnapshot) {
      if (profilesSnapshot.documents.isNotEmpty) {
        var profiles = profilesSnapshot.documents
            .where((mappedItem) => mappedItem.data['friends'].toString().contains(username))
            .map((snapshot) => Friend.fromMap(snapshot.data, snapshot.documentID))
            .toList();

        _friendsController.add(profiles);
      }
    });

    return _friendsController.stream;

  }
}