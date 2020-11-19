import 'package:flutter/foundation.dart';

class CircleInvitation {
  final String inviter;
  final String circleId;
  final String documentId;
  final String invitee;

  CircleInvitation({
    @required this.circleId,
    @required this.invitee,
    @required this.inviter,
    this.documentId,
  });
  Map<String, dynamic> toMap() {
    return {
      'invitee' : invitee,
      'circleId': circleId,
      'documentId' : documentId,
      'inviter' : inviter,
    };
  }
  static CircleInvitation fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return CircleInvitation(
      circleId: map['circleId'],
      invitee: map['invitee'],
      inviter: map['inviter'],
      documentId: documentId,
    );
  }
}