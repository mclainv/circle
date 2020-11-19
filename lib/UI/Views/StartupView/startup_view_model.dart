import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartupLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if(hasLoggedInUser) {
      _navigationService.navigateTo(HomeViewRoute);
    }
    else {
      _navigationService.navigateTo(LoginViewRoute);
    }

  }
}