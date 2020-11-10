import 'package:flutter/foundation.dart';

class Friend {
  final String username;
  final String name;
  final String bio;
  final String documentId;

  Friend({
    @required this.name,
    @required this.username,
    @required this.bio,
    this.documentId,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username' : username,
      'bio': bio,
      'documentId' : documentId,
    };
  }
  static Friend fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Friend(
      name: map['name'],
      username: map['username'],
      bio: map['bio'],
      documentId: documentId,
    );
  }
}