import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/authentication_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:flutter/widgets.dart';

import '../locator.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  bool _busy = false;
  bool get busy => _busy;

  User get currentUser => _authenticationService.currentUser;

  void setBusy(bool val) {
    _busy = val;
    notifyListeners();

  }
  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreateCircleViewRoute);
  }
}