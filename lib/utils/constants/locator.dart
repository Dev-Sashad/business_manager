import 'package:get_it/get_it.dart';
import 'package:records/core/services/authentication.dart';
import 'package:records/core/services/firestoreServices.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';
import 'package:records/utils/router/navigationService.dart';


GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ProgressService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FireStoreService());
}
