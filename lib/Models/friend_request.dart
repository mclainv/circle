import 'package:flutter/foundation.dart';

class FriendRequest {
  final String sentFromUsername;
  final String sentToUsername;

  FriendRequest({
    @required this.sentFromUsername,
    @required this.sentToUsername
  });
  Map<String, dynamic> toJson() {
    return {
      'sentFromUsername' : sentFromUsername,
      'sentToUsername': sentToUsername,
    };
  }
  static FriendRequest fromMap(Map<String, dynamic> map, String documentId) {

    if (map == null) return null;

    return FriendRequest(
      sentFromUsername: map['sentFromUsername'],
      sentToUsername: map['sentToUsername'],
    );
  }
}