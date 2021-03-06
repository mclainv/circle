import 'package:circle_app_alpha/UI/Views/menu_view.dart';
import 'package:circle_app_alpha/UI/Views/FriendsView/friends_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'friend_item_view.dart';

class FriendsView extends StatelessWidget {
  FriendsView({Key key}) : super(key: key);
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendsViewModel>.reactive(
      viewModelBuilder: () => FriendsViewModel(),
      onModelReady: (model) {
        model.listenToFriends();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
//        floatingActionButton: FloatingActionButton(
//          backgroundColor: Theme.of(context).primaryColor,
//          child:
//          !model.busy ? Icon(Icons.add) : CircularProgressIndicator(),
//          onPressed: model.navigateToCreateCircleView,
//        ),
        drawer: MenuView(),
        appBar: AppBar(
          title: Text("Arc Flow"),
        ),
        body: model.friends != null
                ? ListView.builder(
              itemCount: model.friends.length,
              itemBuilder: (context, index) =>
                  FriendItemView(friend: model.friends[index]),
            )
                : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor),
              ),
            )),
      );
  }
}