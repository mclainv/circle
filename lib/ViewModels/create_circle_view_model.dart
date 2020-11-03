import 'package:circle_app_alpha/locator.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:circle_app_alpha/Services/dialog_service.dart';
import 'package:circle_app_alpha/Services/firestore_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:flutter/foundation.dart';
import 'package:circle_app_alpha/Models/user.dart';

class CreateCircleViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Circle _edittingCircle;

  bool get _editting => _edittingCircle != null;

  Future createCircle({@required String name, @required String memberUsername}) async {
    setBusy(true);

    var result;

    if (!_editting) {
      result = await _firestoreService
          .createCircle(Circle(name: name, memberUsername: memberUsername, creatorUser: currentUser.id));
    } else {
      result = await _firestoreService.updateCircle(Circle(
        name: name,
        creatorUser: _edittingCircle.creatorUser,
        memberUsername: _edittingCircle.memberUsername,
        documentId: _edittingCircle.documentId,
      ));
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create group',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Post successfully Added',
        description: 'Your group has been created',
      );
    }

    _navigationService.pop();
  }

  void setEdittingCircle(Circle edittingCircle) {
    _edittingCircle = edittingCircle;
  }
}