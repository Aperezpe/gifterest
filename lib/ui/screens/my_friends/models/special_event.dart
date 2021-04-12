import 'package:bonobo/ui/models/person.dart';
// import 'package:bonobo/ui/screens/my_friends/models/friend.dart';

class SpecialEvent {
  SpecialEvent({
    this.id,
    this.name,
    this.date,
    this.isConcurrent: false,
    this.personId,
  });
  String id;
  String name;
  DateTime date;
  bool isConcurrent;
  String personId;

  factory SpecialEvent.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int startMilliseconds = data['date'];

    final String name = data['name'];
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(startMilliseconds);
    final bool isConcurrent = data['is_concurrent'];
    final String personId = data['person_id'];

    return SpecialEvent(
      id: documentId,
      name: name,
      date: date,
      isConcurrent: isConcurrent,
      personId: personId,
    );
  }

  Map<String, dynamic> toMap(String _personId) {
    return {
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'is_concurrent': isConcurrent,
      'person_id': _personId,
    };
  }
}

class FriendSpecialEvents {
  static List<SpecialEvent> getFriendSpecialEvents(
    Person person,
    List<SpecialEvent> allSpecialEvents,
  ) {
    final friendSpecialEvents = allSpecialEvents
        .where((event) => event.personId == person?.id)
        .toList();
    if (friendSpecialEvents.isEmpty) return [];
    return friendSpecialEvents;
  }

  Map<String, List<SpecialEvent>> upcomingEvents = {};
}
