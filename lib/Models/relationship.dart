import 'package:flutter/foundation.dart';

class Relationship {
  final String sappho;
  final String hetaera;

  Relationship({
    @required this.sappho,
    @required this.hetaera
  });
  Map<String, dynamic> toJson() {
    return {
      'sappho' : sappho,
      'hetaera': hetaera,
    };
  }
  static Relationship fromMap(Map<String, dynamic> map, String documentId) {

    if (map == null) return null;

    return Relationship(
      sappho: map['sappho'],
      hetaera: map['hetaera'],
    );
  }
}