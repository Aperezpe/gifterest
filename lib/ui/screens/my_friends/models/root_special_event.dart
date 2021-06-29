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

  factory RootSpecialEvent.fromMap(
    Map<String, dynamic> data,
    String documentId,
  ) {
    if (data == null) {
      return null;
    }
    final int startMilliseconds = data['date'];

    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(startMilliseconds);
    final bool oneTimeEvent = data['one_time_event'];
    final String eventName = data['event_name'];
    final String gender = data['gender'];
    final String friendName = data['friend_name'];
    final String uid = data['uid'];

    return RootSpecialEvent(
      id: documentId,
      date: date,
      oneTimeEvent: oneTimeEvent,
      eventName: eventName,
      gender: gender,
      friendName: friendName,
      uid: uid,
    );
  }

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
