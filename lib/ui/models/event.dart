import 'package:flutter/foundation.dart';

// TODO: Write test for Event model
class Event {
  Event({@required this.name});
  String name;

  factory Event.fromMap(Map<String, dynamic> data, String nameId) {
    if (data == null) {
      return null;
    }

    return Event(
      name: nameId,
    );
  }
}
