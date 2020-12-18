import 'package:bonobo/services/auth.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/set_friend_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'models/friend.dart';
import 'models/special_event.dart';

class MyFriendsPage extends StatelessWidget {
  MyFriendsPage({
    @required this.database,
    @required this.allSpecialEvents,
    @required this.auth,
  });
  final Auth auth;
  final FirestoreDatabase database;
  final List<SpecialEvent> allSpecialEvents;

  void _deleteFriend(Friend friend) {
    database.deleteFriend(friend);

    for (SpecialEvent event in allSpecialEvents) {
      if (event.friendId == friend.id) {
        database.deleteSpecialEvent(event);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
        actions: [
          FloatingActionButton(onPressed: auth.signOut, child: Text("Sign Out"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => SetFriendForm.show(
          context,
          allSpecialEvents: allSpecialEvents,
        ),
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
          return ListItemsBuilder<Friend>(
            snapshot: snapshot,
            itemBuilder: (context, friend) => _buildFriendCard(context, friend),
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
            friend: friend,
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => SetFriendForm.show(
            context,
            friend: friend,
            allSpecialEvents: allSpecialEvents,
          ),
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
