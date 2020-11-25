import 'package:bonobo/services/database.dart';
import 'package:flutter/foundation.dart';

import 'friend.dart';

class SetFriendModel {
  SetFriendModel({
    @required this.uid,
    @required this.database,
    this.name = "",
    this.age = 0,
    this.friend,
  });
  final String uid;
  final FirestoreDatabase database;
  String name;
  int age;
  Friend friend;

  bool get isNewFriend => friend == null;

  /// [Adding new friend]: Returns a friend instance with the data gathered
  /// from from form + initial valules
  ///
  /// [Editing friend]: Returns friend instance with data gathered from form +
  /// previous values on friend instance
  Friend getFriend() {
    return Friend(
      id: isNewFriend ? documentIdFromCurrentDate() : friend.id,
      uid: uid,
      name: name,
      age: age,
      interests: isNewFriend ? [] : friend.interests,
      specialDates: isNewFriend ? [] : friend.specialDates,
    );
  }

  Future<void> submit() async {
    try {
      await database.setFriend(getFriend());
    } catch (e) {
      rethrow;
    }
  }

  void updateName(String name) => updateWith(name: name);
  void updateAge(int age) => updateWith(age: age);

  void updateWith({
    String name,
    int age,
  }) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
  }
}
