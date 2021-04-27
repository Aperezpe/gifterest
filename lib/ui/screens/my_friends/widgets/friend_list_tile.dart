import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/dates.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  FriendListTile({
    Key key,
    @required this.onTap,
    @required this.person,
    @required this.model,
  }) : super(key: key);
  final VoidCallback onTap;
  final Person person;
  final MyFriendsPageModel model;

  int get remainingDays {
    if (model.upcomingEvents.containsKey(person.id)) {
      return Dates.getRemainingDays(
          model.upcomingEvents[person.id].elementAt(0).date);
    }
    return -1;
  }

  String get mostRescentEvent =>
      model.upcomingEvents[person.id].elementAt(0).name;

  Color get remainingDaysColor {
    if (remainingDays <= 14)
      return Colors.red;
    else if (remainingDays <= 30) return Color.fromRGBO(255, 204, 0, 1);
    return Colors.green;
  }

  String get daysText {
    if (remainingDays == 0) {
      return "Today";
    } else if (remainingDays == 1) {
      return "Day";
    }
    return "Days";
  }

  @override
  Widget build(BuildContext context) {
    if (remainingDays == -1) return Container();
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 85,
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${person.name}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$mostRescentEvent",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.only(right: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$remainingDays',
                      style: TextStyle(
                        fontSize: 24,
                        color: remainingDaysColor,
                      ),
                    ),
                    Text(
                      daysText,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
