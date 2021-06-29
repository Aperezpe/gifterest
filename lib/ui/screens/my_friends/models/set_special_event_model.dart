import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/models/root_special_event.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetSpecialEventModel extends ChangeNotifier {
  SetSpecialEventModel({
    @required this.person,
    @required this.database,
    @required this.allSpecialEvents,
    @required this.isNewFriend,
  }) {
    friendSpecialEvents =
        FriendSpecialEvents.getFriendSpecialEvents(person, allSpecialEvents);

    /// Create a Birthday event by default to increase friend setup speed
    final now = DateTime.now();
    if (friendSpecialEvents.isEmpty && isNewFriend)
      friendSpecialEvents = [
        SpecialEvent(
          id: documentUUID(),
          name: "Birthday",
          date: DateTime(now.year, now.month, now.day),
          personId: person.id,
        ),
      ];
    onDeleteSpecialEvents = [];
  }

  final Person person;
  final FirestoreDatabase database;
  final bool isNewFriend;
  final List<SpecialEvent> allSpecialEvents;
  List<SpecialEvent> friendSpecialEvents = [];
  List<SpecialEvent> onDeleteSpecialEvents;

  bool get isEmpty => friendSpecialEvents.isEmpty;

  void addSpecialEvent(List<String> events) {
    friendSpecialEvents.add(SpecialEvent(
      id: documentUUID(),
      name: events[0],
      date: DateTime.now(),
      personId: person.id,
    ));
    notifyListeners();
  }

  void updateSpecialEvent(
    int index, {
    String name,
    DateTime date,
    bool oneTimeEvent,
  }) {
    friendSpecialEvents[index] = SpecialEvent(
        id: friendSpecialEvents[index].id,
        name: name ?? friendSpecialEvents[index].name,
        date: date ?? friendSpecialEvents[index].date,
        oneTimeEvent: oneTimeEvent ?? friendSpecialEvents[index].oneTimeEvent);

    notifyListeners();
  }

  void deleteSpecialEvent(int index, SpecialEvent specialEvent) {
    friendSpecialEvents.removeAt(index);
    onDeleteSpecialEvents.add(specialEvent);

    notifyListeners();
  }

  Future<void> onSave() async {
    try {
      if (person.interests.isEmpty)
        throw PlatformException(
          code: "01",
          message: "User has to re-select interest",
        );

      await database.setPerson(person);
      for (SpecialEvent event in friendSpecialEvents) {
        await database.setSpecialEvent(event, person);
        await database.setRootSpecialEvent(
          RootSpecialEvent(
            date: event.date,
            eventName: event.name,
            friendName: person.name,
            oneTimeEvent: event.oneTimeEvent,
          ),
          event,
          person,
        );
      }
      for (SpecialEvent event in onDeleteSpecialEvents) {
        await database.deleteSpecialEvent(event);
        await database.deleteRootSpecialEvent(event);
      }
    } catch (e) {
      rethrow;
    }
  }

  void goToInterestsPage(BuildContext context) {
    SetInterestsPage.show(
      context,
      // database: database,
      person: person,
      mainPage: MyFriendsPage(),
      friendSpecialEvents: friendSpecialEvents,
      isNewFriend: isNewFriend,
      onDeleteSpecialEvents: onDeleteSpecialEvents,
    );
  }
}
