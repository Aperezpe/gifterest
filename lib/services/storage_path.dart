import 'package:bonobo/ui/screens/my_friends/models/friend.dart';

class StoragePath {
  static String defaultProfileImage() => "/placeholder.jpg";

  static String profileImage(String uid, Friend friend) =>
      "/$uid/${friend.id}-profileImage.jpg";
}
