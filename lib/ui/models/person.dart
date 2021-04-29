import 'package:flutter/foundation.dart';

abstract class Person {
  Person({
    @required this.id,
    @required this.name,
    @required this.gender,
    @required this.age,
    @required this.interests,
  });
  String id;
  String name;
  String gender;
  int age;
  List<dynamic> interests;

  Map<String, dynamic> toMap();
}
