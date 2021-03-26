import 'package:bonobo/ui/screens/favorites/favorites_page.dart';
import 'package:get_it/get_it.dart';
import 'favorites.dart';

///Need to use Get It to be able to share class instance between any widget in widget tree
final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<Favorites>(() => Favorites());
}
