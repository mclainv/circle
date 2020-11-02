import 'package:flutter/foundation.dart';

class Circle {
  final String title;
  final String circleId;
  final String fromUser;
  final String toUser;

  Circle({
    @required this.fromUser,
    @required this.toUser,
    this.circleId,
    this.title,
});
  Map<String, dynamic> toMap() {
    return {
      'fromUser': fromUser,
       'toUser' : toUser,
         'title': title,
     'circleId' : circleId,
    };
  }
  static Circle fromMap(Map<String, dynamic> map, String circleId) {
    if (map == null) return null;

    return Circle(
      title: map['title'],
      fromUser: map['fromUser'],
      toUser: map['toUser'],
      circleId: circleId,
    );
  }
}