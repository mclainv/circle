import 'package:circle_app_alpha/locator.dart';
import 'package:circle_app_alpha/Services/authentication_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();



}