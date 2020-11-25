import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/material.dart';

class FriendPage extends StatelessWidget {
  FriendPage({@required this.friend});
  final Friend friend;

  static Future<void> show(
    BuildContext context, {
    Friend friend,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FriendPage(friend: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: friend.interests.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${friend.interests[index]}'),
              );
            }),
      ),
    );
  }
}
