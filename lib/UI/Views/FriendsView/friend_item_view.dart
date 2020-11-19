import 'package:circle_app_alpha/Models/friend.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../menu_view.dart';
import 'friend_item_view_model.dart';

class FriendItemView extends StatelessWidget {
  @required final Friend friend;
  const FriendItemView({
    Key key,
    @required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendItemViewModel>.reactive(
      viewModelBuilder: () => FriendItemViewModel(),
      onModelReady: (model) {
//        model.listenToFriends();
      },
      builder: (context, model, child) =>
          Card(
          elevation: 8,
          margin: new EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9)),
              alignment: Alignment.center,
                child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.0, color: Colors.white24))),
                      child: Icon(Icons.autorenew, color: Colors.white),
                    ),
                    title: Text(
                      friend.name,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.person, color: Colors.pinkAccent),
                        Text(friend.username, style: TextStyle(color: Colors.white))
                      ],
                    ),
                    trailing:
                    Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
                ),
            ),
          ),
    );
  }
}