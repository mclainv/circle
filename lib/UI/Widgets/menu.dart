import 'package:flutter/material.dart';
import 'package:circle_app_alpha/Models/user.dart';

class DrawerMenu extends StatefulWidget {
  DrawerMenu();

  @override
  _DrawerMenu createState() => _DrawerMenu();
}

class _DrawerMenu extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
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
    );
  }
}