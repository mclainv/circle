import 'package:flutter/foundation.dart';

class Circle {
  final String name;
  final String documentId;
  final String creatorUser;
  final String memberUsername;

  Circle({
    @required this.creatorUser,
    @required this.memberUsername,
    this.documentId,
    this.name,
});
  Map<String, dynamic> toMap() {
    return {
      'creatorUser': creatorUser,
       'memberUsername' : memberUsername,
         'name': name,
     'documentId' : documentId,
    };
  }
  static Circle fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Circle(
      name: map['name'],
      creatorUser: map['creatorUser'],
      memberUsername: map['memberUsername'],
      documentId: documentId,
    );
  }
}