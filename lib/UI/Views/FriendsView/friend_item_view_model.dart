import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Services/CustomServices/circle_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';

class FriendItemViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final CircleService _circleService = locator<CircleService>();

  void inviteToCircle(int index, List<Friend> friends) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to leave this Circle?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _circleService.inviteToCircle(friends[index], currentUser);
      setBusy(false);
    }
  }

}