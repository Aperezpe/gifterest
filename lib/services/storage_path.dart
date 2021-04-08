import 'package:bonobo/ui/models/person.dart';

class StoragePath {
  static String get defaultProfileImage => "/placeholder.jpg";

  static String friendProfileImage(String uid, Person person) =>
      "/$uid/${person.id}/profileImage.jpg";
}
