import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';

import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendPageModel extends ChangeNotifier {
  FriendPageModel({
    @required this.database,
    @required this.friend,
    @required this.friendSpecialEvents,
  }) : assert(friend != null, friendSpecialEvents != null);

  final FirestoreDatabase database;
  final Friend friend;
  final List<SpecialEvent> friendSpecialEvents;
  FirebaseStorageService firebaseStorage;
  RangeValues currentRangeValues = RangeValues(0, 100);
  int get startValue => currentRangeValues.start.round();
  int get endValue => currentRangeValues.end.round();

  void updateBudget(RangeValues values) {
    currentRangeValues = values;
    print(currentRangeValues);
    notifyListeners();
  }
}
