import 'package:gifterest/flutter_notifications.dart';
import 'package:gifterest/resize/layout_info.dart';
import 'package:gifterest/ui/models/gender.dart';
import 'package:gifterest/ui/screens/favorites.dart';
import 'package:gifterest/ui/screens/landing/landing_page.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

class AppUserInfo {
  String displayName;

  String setName(String value) => displayName = value;
}

void setupLocator() {
  locator.registerLazySingleton(() => FavoritesController());
  locator.registerLazySingleton(() => AppUserInfo());
  locator.registerLazySingleton(() => GenderProvider());
  locator.registerLazySingleton(() => LayoutInfo());
  locator.registerLazySingleton(() => NotificationSettingsLocal());
}
