import 'package:circle_app_alpha/Managers/locator.dart';
import 'package:circle_app_alpha/Models/friend.dart';
import 'package:circle_app_alpha/Services/CustomServices/friend_service.dart';
import 'package:stacked/stacked.dart';

class FriendListFutureView extends FutureViewModel<List<Friend>> {

  FriendService _friendService = locator<FriendService>();
  List<Friend> _friends;
  Future get friends => futureToRun();


  Future<List<Friend>> futureToRun() async {

    return _friends;
  }



}