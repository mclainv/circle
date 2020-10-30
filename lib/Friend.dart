import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id;
  final String username;
  Friend({this.id, this.username});
  Friend.fromMap(Map<String, dynamic> data)
      : this(id: data['id'], username: data['title'] ?? false);

  Map<String, dynamic> toMap() => {
    'id': this.id,
    'title': this.username,
  };
}