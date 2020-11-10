import 'package:circle_app_alpha/UI/Widgets/menu.dart';
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child:
          !model.busy ? Icon(Icons.add) : CircularProgressIndicator(),
          onPressed: model.navigateToCreateCircleView,
        ),
        drawer: DrawerMenu(),
        appBar: AppBar(
          title: Text("Arc Flow"),
        ),
        body: Container(),
      ),
    );
  }
}