import 'package:circle_app_alpha/UI/Views/menu_view.dart';
import 'package:circle_app_alpha/UI/Views/HomeView/Dashboard/dashboard.dart';
import 'package:circle_app_alpha/UI/Views/HomeView/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {

  HomeView({Key key}) : super(key: key);
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.listenToCircles(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child:
          !model.busy ? Icon(Icons.add) : CircularProgressIndicator(),
          onPressed: model.navigateToCreateCircleView,
        ),
        drawer: MenuView(),
        appBar: AppBar(
          title: Text("Arc Flow"),
        ),
        body: dashboard(context, model.circles, model.leaveCircle, model.editCircle),
      ),
    );
  }
}