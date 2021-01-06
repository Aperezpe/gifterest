import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'friend.dart';

class SetSpecialEventModel extends ChangeNotifier {
  SetSpecialEventModel({
    @required this.friend,
    @required this.database,
    @required this.friendSpecialEvents,
    @required this.isNewFriend,
  }) {
    if (friendSpecialEvents == null) friendSpecialEvents = [];
    onDeleteSpecialEvents = [];
  }

  final Friend friend;
  final FirestoreDatabase database;
  final bool isNewFriend;
  List<SpecialEvent> friendSpecialEvents;
  List<SpecialEvent> onDeleteSpecialEvents;

  bool get isEmpty => friendSpecialEvents.isEmpty;

  void addSpecialEvent(List<String> events) {
    friendSpecialEvents.add(SpecialEvent(
      id: documentUUID(),
      name: events[0],
      date: DateTime.now(),
      friendId: friend.id,
    ));
    notifyListeners();
  }

  void updateSpecialEvent(
    int index, {
    String name,
    DateTime date,
    bool isConcurrent,
  }) {
    friendSpecialEvents[index] = SpecialEvent(
        id: friendSpecialEvents[index].id,
        name: name ?? friendSpecialEvents[index].name,
        date: date ?? friendSpecialEvents[index].date,
        isConcurrent: isConcurrent ?? friendSpecialEvents[index].isConcurrent);

    notifyListeners();
  }

  void deleteSpecialEvent(int index, SpecialEvent specialEvent) {
    friendSpecialEvents.removeAt(index);
    onDeleteSpecialEvents.add(specialEvent);

    notifyListeners();
  }

  Future<void> onSave() async {
    try {
      await database.setFriend(friend);
      for (SpecialEvent event in friendSpecialEvents) {
        await database.setSpecialEvent(event, friend);
      }
      for (SpecialEvent event in onDeleteSpecialEvents) {
        await database.deleteSpecialEvent(event);
      }
    } catch (e) {
      rethrow;
    }
  }

  void goToInterestsPage(BuildContext context) {
    SetInterestsPage.show(
      context,
      database: database,
      friend: friend,
      friendSpecialEvents: friendSpecialEvents,
      isNewFriend: isNewFriend,
      onDeleteSpecialEvents: onDeleteSpecialEvents,
    );
  }
}
