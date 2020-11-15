import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Models/relationship.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/Services/dialog_service.dart';
import 'package:circle_app_alpha/locator.dart';
import 'package:circle_app_alpha/Services/authentication_service.dart';
import 'package:circle_app_alpha/Services/firestore_service.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/ViewModels/base_model.dart';
import 'package:circle_app_alpha/Constants/route_names.dart';
import 'package:circle_app_alpha/Models/circle.dart';

class FriendsViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<Relationship> _relationships;

  List<Friend> _friends;

  List<Friend> get friends => _friends;


  void listenToFriends() {
    setBusy(true);
    String username = currentUser.username;
    _firestoreService.listenToRelationshipsRealTime(username).listen((relationshipData) {
      List<Friend> updatedFriends = friendsData;
      if (updatedFriends != null && updatedFriends.length > 0) {
        _friends = updatedFriends;

        notifyListeners();
      }


      setBusy(false);
    });
  }
}