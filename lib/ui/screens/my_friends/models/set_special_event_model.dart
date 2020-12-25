import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/event.dart';
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
  int eventDropdownValue = 0;

  bool get isEmpty => friendSpecialEvents.isEmpty;

  void initializeEventsDropdownValues(
      List<Event> events, SpecialEvent specialEvent) {
    for (int i = 0; i < events.length; i++) {
      if (events[i].name == specialEvent.name) {
        eventDropdownValue = i;
        break;
      }
    }
  }

  void onEventsDropdownChange(
    int value,
    List<Event> events,
    SpecialEvent specialEvent,
  ) {
    final eventName = events[value].name;
    eventDropdownValue = value;
    updateSpecialEventName(specialEvent.id, eventName);
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

  void updateSpecialEventName(String eventId, String name) =>
      updateSpecialEvent(eventId, name: name);

  void updateSpecialEventDate(String eventId, DateTime date) =>
      updateSpecialEvent(eventId, date: date);

  void updateSpecialEventConcurrent(String eventId, bool isConcurrent) =>
      updateSpecialEvent(eventId, isConcurrent: isConcurrent);
}
