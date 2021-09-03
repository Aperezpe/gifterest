import 'package:gifterest/services/database.dart';
import 'package:gifterest/ui/models/app_user.dart';
import 'package:gifterest/ui/models/friend.dart';
import 'package:gifterest/ui/models/gender.dart';
import 'package:gifterest/ui/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gifterest/extensions/age_calculator.dart';

class SetFormModel extends ChangeNotifier {
  SetFormModel({
    @required this.genders,
    @required this.database,
    @required this.person,
    @required this.uid,
    this.isNew: false,
  }) {
    name = person?.name ?? "";
    age = person?.age;
    dob = isUser ? person?.dob ?? dob : null;
    genderTypes = genders.map((gender) => gender.type).toList();
    initializeGenderDropdownValue();
    initializeAgeRange();
  }
  final String uid;
  final FirestoreDatabase database;
  final List<Gender> genders;
  final bool isNew;

  dynamic person;
  int initialGenderValue = 0;
  List<int> ageRange;
  List<String> genderTypes;

  String name = "";
  int age = 0;
  DateTime dob = DateTime.now();

  bool get isUser => person?.id == database.uid;

  /// [Adding new person]: Returns a person object with the data gathered
  /// from from form + initial valules
  ///
  /// [Editing person]: Returns person object with data gathered from form +
  /// previous values on friend instance
  ///
  /// Used in submit() and setInterestPage.

  Future<void> onSave() async {
    try {
      if (ageRangeChanged() || genderChanged())
        throw PlatformException(
          code: "01",
          message: "User has to re-select interests",
        );
      await database.setPerson(setPerson());
    } catch (e) {
      rethrow;
    }
  }

  void initializeGenderDropdownValue() {
    if (isNew) return;
    initialGenderValue = genderTypes.indexOf(person.gender);
  }

  List<String> getGenderTypes(List<Gender> genders) {
    return genders.map((gender) => gender.type).toList();
  }

  void initializeAgeRange() {
    if (isNew) return;
    if (isNew) return;
    if (person.age >= 0 && person.age <= 2) {
      ageRange = [0, 2];
    } else if (person.age >= 3 && person.age <= 11) {
      ageRange = [3, 11];
    } else {
      ageRange = [12, 100];
    }
  }

  bool genderChanged() {
    if (isNew) return false;
    if (genders[initialGenderValue].type != person.gender) {
      return true;
    }
    return false;
  }

  bool ageRangeChanged() {
    if (isNew) return false;
    if (person.age != age) {
      if (age >= ageRange[0] && age <= ageRange[1]) return false;
      return true;
    }
    return false;
  }

  void onGenderDropdownChange(int value) => initialGenderValue = value;

  void updateName(String name) => updateWith(name: name);
  void updateAge(int age) => updateWith(age: age);
  void changeDob(DateTime _dob) {
    updateWith(
      dob: _dob,
      age: _dob.getAge(_dob),
    );
  }

  void updateWith({String name, int age, DateTime dob}) {
    this.name = name ?? this.name;
    this.age = age ?? this.age;
    this.dob = dob ?? this.dob;
    notifyListeners();
  }

  Person setPerson() {
    return isUser
        ? AppUser(
            id: person.id,
            name: name,
            gender: genders[initialGenderValue].type,
            age: age,
            interests:
                (ageRangeChanged() || genderChanged()) ? [] : person.interests,
            dob: dob,
          )
        : Friend(
            id: isNew ? documentIdFromCurrentDate() : person.id,
            name: name,
            age: age,
            gender: genders[initialGenderValue].type,
            interests: (isNew || ageRangeChanged() || genderChanged())
                ? []
                : person.interests,
          );
  }
}
