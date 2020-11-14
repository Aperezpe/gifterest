import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/set_friend_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'models/friend.dart';

class MyFriendsPage extends StatelessWidget {
  MyFriendsPage({@required this.database});
  final FirestoreDatabase database;

  static Widget show(BuildContext context) {
    return Consumer<Database>(
      builder: (context, database, _) {
        return MyFriendsPage(
          database: database,
        );
      },
    );
  }

  void _deleteFriend(Friend friend) => database.deleteFriend(friend);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => SetFriendForm.show(context),
        child: Icon(Icons.add),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Friend>>(
      stream: database.friendsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final friends = snapshot.data;
          final children = friends
              .map((friend) => _buildFriendCard(context, friend))
              .toList();
          return ListView(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Some error occured"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildFriendCard(BuildContext context, Friend friend) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.18,
      child: Container(
        child: FriendListTile(
          friend: friend,
          onTap: () => FriendPage.show(
            context,
            database: database,
            friend: friend,
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => SetFriendForm.show(context, friend: friend),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteFriend(friend),
        ),
      ],
    );
  }
}
