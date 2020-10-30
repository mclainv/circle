import 'package:circle_app_alpha/Services/authentication_service.dart';
import 'package:circle_app_alpha/Services/firestore_service.dart';
import 'package:get_it/get_it.dart';
import 'package:circle_app_alpha/Services/navigation_service.dart';
import 'package:circle_app_alpha/Services/dialog_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => DialogService());

}