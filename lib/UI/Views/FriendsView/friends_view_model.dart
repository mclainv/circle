import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Models/relationship.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/CustomServices/friend_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/dialog_service.dart';
import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/firestore_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:stacked/stacked.dart';

class FriendsViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FriendService _friendsService = locator<FriendService>();
  User get currentUser => _authenticationService.currentUser;

  List<Friend> _friends;

  List<Friend> get friends => _friends;

  void listenToFriends() {
      setBusy(true);
      String username = currentUser.getUsername();
      print("almost listening");
      _friendsService.listenToProfilesRealTime(username).listen((profilesData) {
        print("now we are listening");
        List<Friend> updatedFriends = profilesData;
        if (updatedFriends != null && updatedFriends.length > 0) {
          _friends = updatedFriends;

          notifyListeners();
        }

        setBusy(false);
      });
  }
}