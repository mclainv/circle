import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/dialog_service.dart';
import 'package:circle_app_alpha/locator.dart';
import 'package:circle_app_alpha/Services/authentication_service.dart';
import 'package:circle_app_alpha/Services/firestore_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/circle.dart';

class MenuViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

}