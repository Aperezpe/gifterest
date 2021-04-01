import 'package:bonobo/ui/screens/my_friends/dates.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';

import 'models/friend.dart';

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

  DateTime get mostRescentDate => model.mostRescentEvent(friend).date;
  String get mostRescentEvent => model.mostRescentEvent(friend).name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.all(8),
      leading: ClipOval(
        child: Image(image: backgroundImage),
      ),
      title: Text("${friend.name}", style: TextStyle(fontSize: 18)),
      subtitle: Text(
        "${Dates.getRemainingDays(mostRescentDate)} days for ${friend.name}\'s $mostRescentEvent",
        style: TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
