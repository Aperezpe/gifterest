import 'package:flutter/foundation.dart';

class Friend {
  Friend({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.age,
  }) : assert(uid != null);

  String id;
  String uid;
  String name;
  int age;

  factory Friend.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int age = data['age'];
    final String uid = data['uid'];

    return Friend(
      id: documentId,
      uid: uid,
      name: name,
      age: age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'uid': uid,
    };
  }
}
