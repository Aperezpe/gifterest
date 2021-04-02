import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/error_page.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/platform_alert_dialog.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:bonobo/ui/screens/my_friends/set_friend_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'models/friend.dart';
import 'models/special_event.dart';

class MyFriendsPage extends StatefulWidget {
  MyFriendsPage({Key key}) : super(key: key);

  static String get routeName => "my-friends-page";

  @override
  _MyFriendsPageState createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  final _silableController = SlidableController();

  void _deleteFriend(BuildContext context, Friend friend) async {
    final model = Provider.of<MyFriendsPageModel>(context, listen: false);
    try {
      final yes = await PlatformAlertDialog(
        title: "Delete?",
        content: "Are you sure want to delete ${friend.name}?",
        defaultAtionText: "Yes",
        cancelActionText: "Cancel",
      ).show(context);
      if (yes) await model.deleteFriend(friend);
    } catch (e) {
      await PlatformAlertDialog(
        title: "Error",
        content: "Something went wrong",
        defaultAtionText: "Ok",
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

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
      body: StreamBuilder<List<SpecialEvent>>(
        stream: database.specialEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allSpecialEvents = snapshot.data;
            return StreamBuilder<List<Friend>>(
              stream: database.friendsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final friends = snapshot.data;
                  return ChangeNotifierProvider<MyFriendsPageModel>(
                    create: (context) => MyFriendsPageModel(
                      database: database,
                      allSpecialEvents: allSpecialEvents,
                      friends: friends,
                    ),
                    builder: (context, child) {
                      final model = Provider.of<MyFriendsPageModel>(context,
                          listen: false);
                      return ListItemsBuilder(
                        items: model.friends,
                        itemBuilder: (context, friend) =>
                            _buildFriendCard(context, friend),
                      );
                    },
                  );
                }
                if (snapshot.hasError) ErrorPage(snapshot.error);
                return LoadingScreen();
              },
            );
          }
          if (snapshot.hasError) ErrorPage(snapshot.error);
          return LoadingScreen();
        },
      ),
      drawer: AppDrawer(
        currentChildRouteName: MyFriendsPage.routeName,
      ),
    );
  }

  Widget _buildFriendCard(BuildContext context, Friend friend) {
    final model = Provider.of<MyFriendsPageModel>(context, listen: false);

    return Slidable(
      key: Key("slidable-${friend.id}"),
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      controller: _silableController,
      actionExtentRatio: 0.18,
      child: Builder(builder: (context) {
        return Container(
          child: FriendListTile(
            backgroundImage: NetworkImage(friend.imageUrl),
            model: model,
            friend: friend,
            onTap: () async {
              Slidable.of(context)?.open();
              Slidable.of(context)?.close();

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FriendPage(
                    database: model.database,
                    friend: friend,
                    friendSpecialEvents: model.getFriendSpecialEvents(friend),
                  ),
                ),
              );
            },
          ),
        );
      }),
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
          onTap: () => _deleteFriend(context, friend),
        ),
      ],
    );
  }
}
