import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/set_special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'friend.dart';

class SetFriendModel extends ChangeNotifier {
  final String uid;
  final FirestoreDatabase database;
  final List<SpecialEvent> friendSpecialEvents;
  final Friend friend;
  String name = "";
  int age = 0;
  bool isNewFriend;
  SetFriendModel({
    @required this.uid,
    @required this.database,
    @required this.friendSpecialEvents,
    this.friend,
  }) {
    isNewFriend = friend == null ? true : false;
  }

  void goToSpecialEvents(BuildContext context) {
    SetSpecialEvent.show(
      context,
      database: database,
      friend: _newFriend,
      friendSpecialEvents: friendSpecialEvents,
      isNewFriend: isNewFriend,
    );
  }

  /// [Adding new friend]: Returns a friend instance with the data gathered
  /// from from form + initial valules
  ///
  /// [Editing friend]: Returns friend instance with data gathered from form +
  /// previous values on friend instance
  ///
  /// Used in submit() and setInterestPage.

  Friend get _newFriend => Friend(
        id: isNewFriend ? documentIdFromCurrentDate() : friend.id,
        uid: uid,
        name: name,
        age: age,
        interests: isNewFriend ? [] : friend.interests,
      );

  Future<void> onSave() async {
    try {
      await database.setFriend(_newFriend);
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
