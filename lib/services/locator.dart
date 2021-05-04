import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/screens/favorites.dart';
import 'package:bonobo/ui/screens/landing/landing_page.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FavoritesController());
  locator.registerLazySingleton(() => AppUserInfo());
  locator.registerLazySingleton(() => GenderProvider());
}
