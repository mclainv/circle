import 'UI/Views/StartupView/startup_view.dart';
import 'package:flutter/material.dart';
import 'Services/StandardServices/navigation_service.dart';
import 'Services/StandardServices/dialog_service.dart';
import 'Managers/dialog_manager.dart';
import 'UI/router.dart';
import 'Managers/locator.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 9, 202, 172),
        backgroundColor: Color.fromARGB(255, 26, 27, 30),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Open Sans',
        ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}