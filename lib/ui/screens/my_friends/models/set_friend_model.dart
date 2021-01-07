import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/gender.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/set_special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'friend.dart';

class SetFriendModel extends ChangeNotifier {
  final String uid;
  final FirestoreDatabase database;
  final List<SpecialEvent> friendSpecialEvents;
  final Friend friend;
  final List<Gender> genders;

  String name = "";
  int age = 0;
  bool isNewFriend;
  int genderDropdownValue = 0;
  List<int> ageRange;

  SetFriendModel({
    @required this.uid,
    @required this.database,
    @required this.friendSpecialEvents,
    @required this.genders,
    this.friend,
  }) {
    isNewFriend = friend == null ? true : false;
    initializeGenderDropdownValue();
    initializeAgeRange();
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
        imageUrl:
            'https://static.vecteezy.com/system/resources/previews/000/556/895/original/vector-cute-cartoon-baby-monkey.jpg',
        gender: genders[genderDropdownValue].type,
        interests: (isNewFriend || ageRangeChanged() || genderChanged())
            ? []
            : friend.interests,
      );

  Future<void> onSave() async {
    try {
      if (ageRangeChanged() || genderChanged())
        throw PlatformException(
          code: "01",
          message: "User has to re-select interests",
        );
      await database.setFriend(_newFriend);
    } catch (e) {
      rethrow;
    }
  }

  void initializeGenderDropdownValue() {
    if (isNewFriend) return;
    final genderTypes = genders.map((gender) => gender.type).toList();
    genderDropdownValue = genderTypes.indexOf(friend.gender);
  }

  void initializeAgeRange() {
    if (isNewFriend) return;
    if (friend.age >= 0 && friend.age <= 2) {
      ageRange = [0, 2];
    } else if (friend.age >= 3 && friend.age <= 11) {
      ageRange = [3, 11];
    } else {
      ageRange = [12, 100];
    }
  }

  bool genderChanged() {
    if (isNewFriend) return false;
    if (genders[genderDropdownValue].type != friend.gender) {
      return true;
    }
    return false;
  }

  bool ageRangeChanged() {
    if (isNewFriend) return false;
    if (friend.age != age) {
      if (age >= ageRange[0] && age <= ageRange[1]) return false;
      return true;
    }
    return false;
  }

  void onGenderDropdownChange(int value) => genderDropdownValue = value;

  void updateName(String name) => updateWith(name: name);
  void updateAge(int age) => updateWith(age: age);

  void updateWith({
    String name,
    int age,
  }) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
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
}
