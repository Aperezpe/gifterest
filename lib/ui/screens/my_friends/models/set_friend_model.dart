import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/event.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'friend.dart';

class SetFriendModel extends ChangeNotifier {
  SetFriendModel({
    @required this.uid,
    @required this.database,
    @required this.allSpecialEvents,
    this.friend,
  });
  final String uid;
  final FirestoreDatabase database;
  final List<SpecialEvent> allSpecialEvents;
  final Friend friend;
  String name = "";
  int age = 0;
  List<SpecialEvent> friendSpecialEvents = [];

  bool get isNewFriend => friend == null;

  void initializeFriendSpecialEvents() {
    friendSpecialEvents = allSpecialEvents
        .where((event) => event.friendId == friend?.id)
        .toList();
  }

  void addSpecialEvent(List<Event> events) {
    friendSpecialEvents.add(SpecialEvent(
      id: documentUUID(),
      name: events[0].name,
      date: DateTime.now(),
    ));

    notifyListeners();
  }

  void updateSpecialEvent(
    String eventId, {
    String name,
    DateTime date,
    bool isConcurrent,
  }) {
    friendSpecialEvents = friendSpecialEvents
        .map(
          (event) => event.id == eventId
              ? SpecialEvent(
                  id: event.id,
                  name: name ?? event.name,
                  date: date ?? event.date,
                  isConcurrent: isConcurrent ?? event.isConcurrent,
                )
              : event,
        )
        .toList();

    notifyListeners();
  }

  void deleteSpecialEvent(SpecialEvent specialEvent) {
    friendSpecialEvents.removeWhere((event) => event.id == specialEvent.id);
    database.deleteSpecialEvent(specialEvent);
    notifyListeners();
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

  void goToInterestsPage(BuildContext context) {
    SetInterestsPage.show(
      context,
      database: database,
      friend: _newFriend,
      friendSpecialEvents: friendSpecialEvents,
    );
  }

  Future<void> submit() async {
    try {
      await database.setFriend(_newFriend);
      for (SpecialEvent event in friendSpecialEvents) {
        await database.setSpecialEvent(event, friend);
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateName(String name) => updateWith(name: name);
  void updateAge(int age) => updateWith(age: age);

  void updateSpecialEventName(String eventId, String name) =>
      updateSpecialEvent(eventId, name: name);

  void updateSpecialEventDate(String eventId, DateTime date) =>
      updateSpecialEvent(eventId, date: date);

  void updateSpecialEventConcurrent(String eventId, bool isConcurrent) =>
      updateSpecialEvent(eventId, isConcurrent: isConcurrent);

  void updateWith({
    String name,
    int age,
  }) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
  }
}
