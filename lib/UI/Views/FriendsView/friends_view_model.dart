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

class FriendsViewModel extends MultipleStreamViewModel {
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FriendService _friendsService = locator<FriendService>();
  User get currentUser => _authenticationService.currentUser;

  static const String _relationshipsKey = 'relationship-stream';
  static const String _friendsKey = 'friend-stream';

  List<Friend> _friends;

  List<Friend> get friends => _friends;

  List<Relationship> _relationships;

  List<Relationship> get relationships => _relationships;

  @override
  Map<String, StreamData> get streamsMap => {
    _relationshipsKey: StreamData<List<Relationship>>(_friendsService.listenToRelationshipsDelayed(currentUser.username)),
    _friendsKey: StreamData<List<Friend>>(_friendsService.listenToProfilesRealTime(relationships, currentUser.username)),
  };

  void listenToRelationships() {
      setBusy(true);
      String username = currentUser.getUsername();
      _friendsService.listenToRelationshipsRealTime(username).listen((relationshipsData) {
        print("Relationship stream");
        List<Relationship> updatedRelationships = relationshipsData;
        if (updatedRelationships != null && updatedRelationships.length > 0) {
          _relationships = updatedRelationships;

          notifyListeners();
        }

        setBusy(false);
      });
  }
  void listenToFriends() {
      setBusy(true);
      String username = currentUser.getUsername();
      print("almost listening");
      _friendsService.listenToProfilesRealTime(relationships, username).listen((profilesData) {
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