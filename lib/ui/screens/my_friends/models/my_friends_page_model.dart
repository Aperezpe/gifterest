import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/dates.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/material.dart';

class MyFriendsPageModel extends ChangeNotifier {
  MyFriendsPageModel({
    @required this.database,
    @required this.allSpecialEvents,
    @required this.friends,
  }) {
    setupUpcomingEvents();
    // sort friends by top most recent event
    friends.sort((friendA, friendB) {
      final firstRemainingA =
          Dates.getRemainingDays(upcomingEvents[friendA.id].elementAt(0).date);
      final firstRemainingB =
          Dates.getRemainingDays(upcomingEvents[friendB.id].elementAt(0).date);

      return firstRemainingA.compareTo(firstRemainingB);
    });

    // Initliaze FriendStorage to use on each friend
    friendStorage = FirebaseFriendStorage(uid: database.uid);
  }

  final FirestoreDatabase database;
  final List<SpecialEvent> allSpecialEvents;
  final List<Person> friends;
  FirebaseFriendStorage friendStorage;

  /// [upcomingEvents] contains a hashmap of
  /// key = friend.id, value = sorted events by remaining days for that event
  /// Every value[0] is the most recent upcoming event
  /// [upcomingEvents] is initialized and populated in constructor
  Map<String, List<SpecialEvent>> upcomingEvents = {};

  void setupUpcomingEvents() {
    print("setting up upcoming events...");
    friends.forEach((friend) => upcomingEvents[friend.id] = []);
    allSpecialEvents.forEach((event) {
      upcomingEvents[event.personId].add(event);
    });
    upcomingEvents.forEach((friendId, specialEvents) {
      specialEvents.sort(
        (event1, event2) => Dates.getRemainingDays(event1.date).compareTo(
          Dates.getRemainingDays(event2.date),
        ),
      );
    });
  }

  /// [deleteFriend] deletes friend, profilePic, specialEvents associated to it
  /// and updates [upcomingEvents] hashMap
  Future<void> deleteFriend(Person person) async {
    await friendStorage.deleteProfileImage(person: person); // profilePic
    database.deleteFriend(person); // friend
    for (SpecialEvent event in allSpecialEvents) // specialEvents
    {
      if (event.personId == person.id) {
        database.deleteSpecialEvent(event);
      }
    }
    upcomingEvents.remove(person.id); // updates upcomingEvents

    notifyListeners();
  }
}
