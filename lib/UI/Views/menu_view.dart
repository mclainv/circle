import 'package:circle_app_alpha/ViewModels/menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/UI/Views/menu_view.dart';
import 'package:circle_app_alpha/UI/Views/HomeView/Dashboard/dashboard.dart';
import 'package:circle_app_alpha/UI/Views/HomeView/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class MenuView extends StatelessWidget {
  MenuView({Key key}) : super (key : key);
  Widget build(BuildContext context) {
    return ViewModelBuilder<MenuViewModel>.reactive(
      viewModelBuilder: () => MenuViewModel(),
      onModelReady: (model) => {},
      builder: (context, model, child) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              margin: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Arc Flow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text('Circles'),
              //onTap: (),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends'),
              onTap: () => model.navigateToFriendsView(),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
          ),
        ],
      )
    )
    );
  }
}