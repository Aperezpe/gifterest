import 'package:flutter/foundation.dart';

class Friend {
  Friend({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.age,
    @required this.interests,
  }) : assert(uid != null);

  String id;
  String uid;
  String name;
  int age;
  List<dynamic> interests;

  factory Friend.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int age = data['age'];
    final String uid = data['uid'];
    final List<dynamic> interests = data['interests'];

    return Friend(
      id: documentId,
      uid: uid,
      name: name,
      age: age,
      interests: interests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'uid': uid,
      'interests': interests,
    };
  }
}
