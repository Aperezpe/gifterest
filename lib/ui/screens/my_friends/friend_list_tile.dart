import 'package:flutter/material.dart';

import 'models/friend.dart';

class FriendListTile extends StatelessWidget {
  FriendListTile({@required this.friend, this.onTap});
  final Friend friend;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      leading: CircleAvatar(
        backgroundColor: Colors.indigoAccent,
        child: Text(friend.name[0].toUpperCase()),
      ),
      title: Text("${friend.name}"),
      subtitle: Text("${friend.age}"),
      onTap: onTap,
    );
  }
}
