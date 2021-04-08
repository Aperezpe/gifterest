import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/my_friends/dates.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  FriendListTile({
    Key key,
    @required this.onTap,
    @required this.person,
    @required this.backgroundImage,
    @required this.model,
  }) : super(key: key);
  final VoidCallback onTap;
  final Person person;
  final ImageProvider<Object> backgroundImage;
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
    return Colors.grey;
  }

  String get text1 {
    if (remainingDays == 0) {
      return "Today ";
    } else if (remainingDays == 1) {
      return "$remainingDays day ";
    }
    return "$remainingDays days ";
  }

  String get text2 =>
      remainingDays == 0 ? "is $mostRescentEvent" : "for $mostRescentEvent";

  @override
  Widget build(BuildContext context) {
    if (remainingDays == -1) return Container();
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.all(8),
      leading: ClipOval(
        child: Image(image: backgroundImage),
      ),
      title: Text("${person.name}", style: TextStyle(fontSize: 18)),
      subtitle: RichText(
        text: TextSpan(
          text: text1,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: remainingDaysColor,
          ),
          children: <TextSpan>[
            TextSpan(
              text: text2,
              style:
                  TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
