import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/dialog_service.dart';
import 'package:circle_app_alpha/locator.dart';
import 'package:circle_app_alpha/Services/authentication_service.dart';
import 'package:circle_app_alpha/Services/firestore_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/circle.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<Circle> _circles;

  List<Circle> get circles => _circles;
  User get currentUser => currentUser;
  void listenToCircles() {
    setBusy(true);

    _firestoreService.listenToCirclesRealTime().listen((circlesData) {
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
      await _firestoreService.leaveCircle(_circles[index], currentUser);
      setBusy(false);
    }
  }
  void editCircle(int index) {
    _navigationService.navigateTo(CreateCircleViewRoute,
        arguments: _circles[index]);
  }
}