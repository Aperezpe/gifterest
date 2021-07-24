import 'package:flutter/foundation.dart';

class RootSpecialEvent {
  RootSpecialEvent({
    this.id,
    this.date,
    this.oneTimeEvent: false,
    this.eventName,
    this.friendName,
    this.gender,
    this.uid,
  });
  String id;
  DateTime date;
  bool oneTimeEvent;
  String eventName;
  String gender;
  String friendName;
  String uid;
  
  Map<String, dynamic> toMap({
    @required String uid,
    @required String friendName,
    @required String gender,
  }) {
    return {
      'date': date.microsecondsSinceEpoch,
      'month': date.month,
      'day': date.day,
      'one_time_event': oneTimeEvent,
      'event_name': eventName,
      'gender': gender,
      'friend_name': friendName,
      'uid': uid,
    };
  }
}
