import 'package:bonobo/ui/models/person.dart';
import 'package:flutter/foundation.dart';

class Friend implements Person {
  Friend({
    @required this.id,
    @required this.name,
    @required this.gender,
    @required this.age,
    @required this.interests,
  });

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

  factory Friend.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String gender = data['gender'];
    final int age = data['age'];
    final List<dynamic> interests = data['interests'];

    return Friend(
      id: documentId,
      name: name,
      gender: gender,
      age: age,
      interests: interests,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'interests': interests,
    };
  }

  @override
  String toString() => '''id: $id, name: $name, age: $age, 
      gender: $gender, interests: $interests''';
}
