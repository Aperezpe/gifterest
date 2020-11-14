import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/material.dart';

class FriendPage extends StatelessWidget {
  FriendPage({@required this.database, @required this.friend});
  final FirestoreDatabase database;
  final Friend friend;

  static Future<void> show(
    BuildContext context, {
    FirestoreDatabase database,
    Friend friend,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FriendPage(database: database, friend: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
      ),
    );
  }
}
