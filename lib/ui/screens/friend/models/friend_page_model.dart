import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendPageModel extends ChangeNotifier {
  FriendPageModel({
    @required this.database,
    @required this.friend,
    @required this.friendSpecialEvents,
  }) : assert(friend != null, friendSpecialEvents != null) {
    friendSpecialEvents.map((e) => specialEventsNames.add(e.name)).toList();
    selectedTab = 0;
  }

  final FirestoreDatabase database;
  final Friend friend;
  final List<SpecialEvent> friendSpecialEvents;

  String profileImageUrl =
      'https://static.vecteezy.com/system/resources/previews/000/556/895/original/vector-cute-cartoon-baby-monkey.jpg';

  RangeValues currentRangeValues = RangeValues(0, 100);
  int get startValue => currentRangeValues.start.round();
  int get endValue => currentRangeValues.end.round();

  List<String> specialEventsNames = ["All"];
  int selectedTab;

  Stream<List<Product>> get productsStream => database.productsStream();

  void updateBudget(RangeValues values) {
    currentRangeValues = values;
    notifyListeners();
  }

  void updateSelectedTab(int value) {
    selectedTab = value;
    notifyListeners();
  }
}
