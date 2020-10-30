import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequests {
  final List<String> friendRequests;
  final String uid;

  FriendRequests({this.friendRequests, this.uid});
}