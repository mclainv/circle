import 'package:circle_app_alpha/locator.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:circle_app_alpha/Services/dialog_service.dart';
import 'package:circle_app_alpha/Services/firestore_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:flutter/foundation.dart';

class CreateCircleViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Circle _edittingPost;

  bool get _editting => _edittingPost != null;

  Future addPost({@required String title}) async {
    setBusy(true);

    var result;

    if (!_editting) {
      result = await _firestoreService
          .createCircle(Circle(title: title, fromUser: currentUser.id));
    } else {
      result = await _firestoreService.updateCircle(Circle(
        title: title,
        fromUser: _edittingPost.fromUser,
        circleId: _edittingPost.circleId,
      ));
    }

    setBusy(false);

    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create post',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Post successfully Added',
        description: 'Your post has been created',
      );
    }

    _navigationService.pop();
  }

  void setEdittingPost(Circle edittingPost) {
    _edittingPost = edittingPost;
  }
}