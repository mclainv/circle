import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/CustomServices/circle_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/dialog_service.dart';
import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/firestore_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/circle.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final CircleService _circleService = locator<CircleService>();

  List<Circle> _circles;

  List<Circle> get circles => _circles;

  void listenToCircles() {
    setBusy(true);
    String username = currentUser.username;
    _circleService.listenToCirclesRealTime(username).listen((circlesData) {
      List<Circle> updatedCircles = circlesData;
      if (updatedCircles != null && updatedCircles.length > 0) {
        _circles = updatedCircles;

        notifyListeners();
      }

      setBusy(false);
    });
  }

  Future leaveCircle(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to leave this Circle?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _circleService.leaveCircle(_circles[index], currentUser);
      setBusy(false);
    }
  }
  void editCircle(int index) {
    _navigationService.navigateTo(CreateCircleViewRoute,
        arguments: _circles[index]);
  }
}