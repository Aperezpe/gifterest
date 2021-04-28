import 'package:flutter/foundation.dart';

class Person {
  Person({
    @required this.id,
    @required this.name,
    @required this.gender,
    @required this.age,
    @required this.interests,
    this.dob,
  });

  String id;
  String name;
  String gender;
  int age;
  List<dynamic> interests;
  DateTime dob;

  factory Person.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String gender = data['gender'];
    final int age = data['age'];
    final List<dynamic> interests = data['interests'];
    final int dobMilliseconds = data['dob'];

    return Person(
      id: documentId,
      name: name,
      gender: gender,
      age: age,
      interests: interests,
      dob: DateTime.fromMicrosecondsSinceEpoch(dobMilliseconds),
    );
  }

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
