import 'dart:io';

import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/interests/set_interests_page.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/storage.dart';

class SetSpecialEventModel extends ChangeNotifier {
  SetSpecialEventModel({
    @required this.person,
    @required this.database,
    // @required this.friendSpecialEvents,
    @required this.allSpecialEvents,
    @required this.isNewFriend,
    @required this.firebaseStorageService,
    this.selectedImage,
  }) {
    friendSpecialEvents =
        FriendSpecialEvents.getFriendSpecialEvents(person, allSpecialEvents);

    /// Create a Birthday event by default to increase friend setup speed
    if (friendSpecialEvents.isEmpty && isNewFriend)
      friendSpecialEvents = [
        SpecialEvent(
          id: documentUUID(),
          name: "Birthday",
          date: DateTime.now(),
          personId: person.id,
        ),
      ];
    onDeleteSpecialEvents = [];
  }

  final Person person;
  final FirestoreDatabase database;
  final bool isNewFriend;
  final File selectedImage;
  final List<SpecialEvent> allSpecialEvents;
  List<SpecialEvent> friendSpecialEvents = [];
  List<SpecialEvent> onDeleteSpecialEvents;
  final Storage firebaseStorageService;

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
      if (person.interests.isEmpty)
        throw PlatformException(
          code: "01",
          message: "User has to re-select interest",
        );

      if (selectedImage != null) {
        firebaseStorageService.putProfileImage(
            image: selectedImage, person: person);
        notifyListeners();
        await firebaseStorageService.uploadTask.whenComplete(
          () async => person.imageUrl =
              await firebaseStorageService.getProfileImageURL(person: person),
        );
      } else {
        person.imageUrl = person.imageUrl ??
            await firebaseStorageService.getDefaultProfileImageUrl();
      }

      await database.setPerson(person);
      for (SpecialEvent event in friendSpecialEvents) {
        await database.setSpecialEvent(event, person);
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
      // database: database,
      firebaseStorage: firebaseStorageService,
      person: person,
      mainPage: MyFriendsPage(),
      friendSpecialEvents: friendSpecialEvents,
      isNewFriend: isNewFriend,
      onDeleteSpecialEvents: onDeleteSpecialEvents,
      selectedImage: selectedImage,
    );
  }
}
