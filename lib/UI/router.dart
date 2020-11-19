import 'package:circle_app_alpha/Models/circle.dart';
import 'Views/CreateCircleView/create_circle_view.dart';
import 'Views/FriendsView/friends_view.dart';
import 'Views/HomeView/home_view.dart';
import 'package:flutter/material.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';
import 'Views/SignInView/signin_view.dart';
import 'Views/SignUpView/signup_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case CreateCircleViewRoute:
      var circleToEdit = settings.arguments as Circle;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateCircleView(
          edittingCircle: circleToEdit,
        ),
      );
    case FriendsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: FriendsView(
        ),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
      name: routeName,
  ),
  builder: (_) => viewToShow);
}