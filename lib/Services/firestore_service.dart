import 'dart:async';

import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  final CollectionReference _circlesCollectionReference =
      Firestore.instance.collection('circles');

  final StreamController<List<Circle>> _circlesController =
  StreamController<List<Circle>>.broadcast();

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
  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      return e;
    }
  }
  Future addPost(Circle circle) async {
    try {
      await _circlesCollectionReference.add(circle.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getPostsOnceOff() async {
    try {
      var postDocumentSnapshot = await _circlesCollectionReference.getDocuments();
      if (postDocumentSnapshot.documents.isNotEmpty) {
        return postDocumentSnapshot.documents
            .map((snapshot) => Circle.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream listenToPostsRealTime() {
    // Register the handler for when the posts data changes
    _circlesCollectionReference.snapshots().listen((postsSnapshot) {
      if (postsSnapshot.documents.isNotEmpty) {
        var posts = postsSnapshot.documents
            .map((snapshot) => Circle.fromMap(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.title != null)
            .toList();

        // Add the posts onto the controller
        _circlesController.add(posts);
      }
    });

    return _circlesController.stream;
  }

  Future deleteCircle(String documentId) async {
    await _circlesCollectionReference.document(documentId).delete();
  }

  Future updateCircle(Circle circle) async {
    try {
      await _circlesCollectionReference
          .document(circle.circleId)
          .updateData(circle.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

}