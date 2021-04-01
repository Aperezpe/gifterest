import 'package:bonobo/ui/screens/my_friends/dates.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';

import '../models/friend.dart';

class FriendListTile extends StatelessWidget {
  FriendListTile({
    @required this.friend,
    @required this.backgroundImage,
    @required this.model,
    @required this.onTap,
  });
  final Friend friend;
  final MyFriendsPageModel model;
  final VoidCallback onTap;
  final ImageProvider<Object> backgroundImage;

  int get remainingDays =>
      Dates.getRemainingDays(model.mostRescentEvent(friend).date);
  String get mostRescentEvent => model.mostRescentEvent(friend).name;

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
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.all(8),
      leading: ClipOval(
        child: Image(image: backgroundImage),
      ),
      title: Text("${friend.name}", style: TextStyle(fontSize: 18)),
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
