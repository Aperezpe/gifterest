import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:bonobo/ui/screens/my_friends/set_friend_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'models/friend.dart';
import 'models/special_event.dart';

class MyFriendsPage extends StatelessWidget {
  MyFriendsPage({
    @required this.model,
  });

  final MyFriendsPageModel model;

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<SpecialEvent>>(
      stream: database.specialEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider<MyFriendsPageModel>(
            create: (context) => MyFriendsPageModel(
              database: database,
              allSpecialEvents: snapshot.data,
            ),
            child: Consumer<MyFriendsPageModel>(
              builder: (_, model, __) => MyFriendsPage(
                model: model,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong!"),
          );
        }
        return LoadingScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
        actions: [
          TextButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () => SetFriendForm.show(context),
          )
        ],
      ),
      body: _buildContent(context),
      drawer: AppDrawer(),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Friend>>(
      stream: model.database.friendsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListItemsBuilder<Friend>(
            snapshot: snapshot,
            itemBuilder: (context, friend) => _buildFriendCard(context, friend),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("An error occurred"));
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
          backgroundImage: NetworkImage(friend.imageUrl),
          friend: friend,
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FriendPage(
                  database: model.database,
                  friend: friend,
                  friendSpecialEvents: model.getFriendSpecialEvents(friend),
                ),
              ),
            ),
          },
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
            friendSpecialEvents: model.getFriendSpecialEvents(friend),
          ),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.deleteFriend(context, friend),
        ),
      ],
    );
  }
}
