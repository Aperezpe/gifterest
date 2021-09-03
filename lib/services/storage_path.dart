import 'package:gifterest/ui/models/person.dart';

class StoragePath {
  static String get defaultProfileImage => "/placeholder.jpg";

  static String friendProfileImage(String uid, Person person) =>
      "/$uid/${person.id}/profileImage.jpg";

  static String userProfileImage(String uid) => '$uid/profileImage.jpg';
}
