import 'package:flutter/foundation.dart';

class Relationship {
  final String friend;

  Relationship({
    @required this.friend,
  });
  Map<String, dynamic> toJson() {
    return {
      'hetaera' : friend,
    };
  }
  String getHetaera() {
    return this.friend;
  }
  static Relationship fromMap(Map<String, dynamic> map, String username, String documentId,) {

    if (map['hetaera'] != username) {
      return Relationship(
        friend: map['hetaera'],
      );
    }
    else if (map['sappho'] != username) {
      return Relationship(
        friend: map['sappho'],
      );
    }
    return null;
  }
}