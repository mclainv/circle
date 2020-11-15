import 'package:circle_app_alpha/Services/StandardServices/authentication_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/firestore_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/navigation_service.dart';
import 'package:circle_app_alpha/Services/StandardServices/dialog_service.dart';
import '../Services/CustomServices/circle_service.dart';
import '../Services/CustomServices/friend_service.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => FriendService());
  locator.registerLazySingleton(() => CircleService());

}