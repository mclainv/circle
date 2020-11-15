import 'package:circle_app_alpha/UI/Views/menu_view.dart';
import 'package:circle_app_alpha/UI/Widgets/friend_item.dart';
import 'package:circle_app_alpha/ViewModels/friends_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FriendsView extends StatelessWidget {

  FriendsView({Key key}) : super(key: key);
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendsViewModel>.reactive(
      viewModelBuilder: () => FriendsViewModel(),
      onModelReady: (model) => model.listenToFriends(),
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
        body: new ListView.separated(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            if(model.friends != null) {
              return FriendItem(friend: model.friends.elementAt(index));
            }
            else {
              return Container();
            }
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        )
      ),
    );
  }
}