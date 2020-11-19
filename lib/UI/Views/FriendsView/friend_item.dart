import 'package:circle_app_alpha/Models/friend.dart';
import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  @required final Friend friend;
  const FriendItem({
    Key key,
    @required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 200,
      width: 350,
      margin: const EdgeInsets.only(top: 5, left: 20, right: 15),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Text(friend.name + "  " + friend.username),

        ],

      )
    );
  }

}