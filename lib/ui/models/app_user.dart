import 'package:gifterest/ui/models/person.dart';
import 'package:flutter/foundation.dart';

class AppUser implements Person {
  AppUser(
      {@required this.id,
      @required this.name,
      @required this.gender,
      @required this.age,
      @required this.interests,
      @required this.dob});

  @override
  int age;

  @override
  String gender;

  @override
  String id;

  @override
  List interests;

  @override
  String name;

  DateTime dob;

  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String gender = data['gender'];
    final int age = data['age'];
    final List<dynamic> interests = data['interests'];
    final int dobMilliseconds = data['dob'];

    return AppUser(
      id: documentId,
      name: name,
      gender: gender,
      age: age,
      interests: interests,
      dob: dobMilliseconds != null
          ? DateTime.fromMicrosecondsSinceEpoch(dobMilliseconds)
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'interests': interests,
      'dob': dob.microsecondsSinceEpoch,
    };
  }

  @override
  String toString() => '''id: $id, name: $name, age: $age, 
      gender: $gender, interests: $interests, dob: $dob''';
}
