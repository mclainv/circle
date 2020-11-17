import 'dart:async';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CircleService {
  final CollectionReference _circlesCollectionReference =
  Firestore.instance.collection('circles');

  final StreamController<List<Circle>> _circlesController =
  StreamController<List<Circle>>.broadcast();

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

        // Add the circles onto the controller
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

}