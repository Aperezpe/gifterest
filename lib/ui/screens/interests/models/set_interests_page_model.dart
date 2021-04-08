import 'dart:io';

import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/foundation.dart';

import '../../../models/interest.dart';

class SetInterestsPageModel extends ChangeNotifier {
  SetInterestsPageModel({
    @required this.database,
    @required this.person,
    @required this.friendSpecialEvents,
    @required this.isNewFriend,
    @required this.onDeleteSpecialEvents,
    this.selectedImage,
  }) : assert(person != null) {
    _initializeInterests();
    firebaseStorage = FirebaseStorageService(uid: database.uid, person: person);
  }

  final FirestoreDatabase database;
  final File selectedImage;
  final bool isNewFriend;
  FirebaseStorageService firebaseStorage;
  Person person;
  List<SpecialEvent> friendSpecialEvents;
  List<SpecialEvent> onDeleteSpecialEvents;

  final int interestsAllowed = 5;
  List<String> _selectedInterests = [];

  void _initializeInterests() {
    _selectedInterests =
        person.interests.map((interest) => interest.toString()).toList();
  }

  Stream<List<Interest>> get interestStream => database.interestStream();
  Stream<List<Interest>> get queryInterestsStream =>
      database.queryInterestsStream(person);

  bool get isReadyToSubmit =>
      _selectedInterests.length == interestsAllowed ? true : false;

  String get submitButtonText {
    int remaining = interestsAllowed - _selectedInterests.length;
    if (remaining == 1) {
      return "Add 1 more interest";
    } else if (remaining > 1) {
      return "Add $remaining more interests";
    } else {
      return "Submit";
    }
  }

  Future<void> submit() async {
    person.interests = _selectedInterests;
    if (selectedImage != null) {
      firebaseStorage.putFriendProfileImage(image: selectedImage);
      notifyListeners();
      await firebaseStorage.uploadTask.whenComplete(
        () async =>
            person.imageUrl = await firebaseStorage.getFriendProfileImageURL(),
      );
    } else {
      person.imageUrl =
          person.imageUrl ?? await firebaseStorage.getDefaultProfileImageUrl();
    }

    await database.setFriend(person);
    for (SpecialEvent event in friendSpecialEvents) {
      await database.setSpecialEvent(event, person);
    }
    for (SpecialEvent event in onDeleteSpecialEvents) {
      await database.deleteSpecialEvent(event);
    }
  }

  bool isSelected(String interestName) =>
      _selectedInterests.contains(interestName);

  void tapInterest(Interest interest) {
    if (isSelected(interest.name)) {
      _selectedInterests.remove(interest.name);
    } else if (_selectedInterests.length < interestsAllowed) {
      _selectedInterests.add(interest.name);
    }
    notifyListeners();
  }

  //TODO: bring filters from GridBuilder
  List<dynamic> filterInterests(List<dynamic> interests, dynamic filters) {
    List<dynamic> filteredInterests = [];

    for (var interest in interests) {
      int fromAge = interest.ageRange[0];
      int toAge = interest.ageRange[1];
      bool isBetweenRange = fromAge <= person.age && toAge >= person.age;
      bool isRightGender =
          interest.gender == "any" || interest.gender == person.gender;

      if (isBetweenRange && isRightGender) {
        filteredInterests.add(interest);
      }
    }

    return filteredInterests;
  }
}
