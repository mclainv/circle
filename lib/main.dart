import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DatabaseAndAuth/root_page.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
import 'package:firebase_database/firebase_database.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  FirebaseDatabase database = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Circle',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}