import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/navigation_service.dart';
import 'package:flutter/widgets.dart';

import '../Managers/locator.dart';

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
  Future navigateToCreateCircleView() async {
    await _navigationService.navigateTo(CreateCircleViewRoute);
  }
  Future navigateToFriendsView() async {
    await _navigationService.navigateTo(FriendsViewRoute);
  }
//  Future navigateToProfileView() async {
//    await _navigationService.navigateTo(ProfleViewRoute);
//  }
//  Future navigateToSettingsView() async {
//    await _navigationService.navigateTo(SettingsViewRoute);
//  }
//  Future navigateToCirclesView() async {
//    await _navigationService.navigateTo(CirclesViewRoute);
//  }
//  Future navigateToIndividualCircleView() async {
//    await _navigationService.navigateTo(IndividualCircleViewRoute);
//  }
//  Future navigateToUserProfile() async {
//    await _navigationService.navigateTo(UserProfileViewRoute);
//  }
}