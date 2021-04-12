import 'package:bonobo/services/database.dart';
import 'package:bonobo/services/storage.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/error_page.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/platform_alert_dialog.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'models/special_event.dart';

// TODO: Sacar un snackbar o hacer highlight el friend que acaban de hacer update
class MyFriendsPage extends StatefulWidget {
  MyFriendsPage({Key key}) : super(key: key);

  static String get routeName => "my-friends-page";

  @override
  _MyFriendsPageState createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  final _silableController = SlidableController();

  void _deleteFriend(BuildContext context, Person friend) async {
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
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
        actions: [
          TextButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () => SetPersonForm.create(
              context,
              firebaseStorage: FirebaseFriendStorage(uid: database.uid),
              mainPage: widget,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<SpecialEvent>>(
        stream: database.specialEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allSpecialEvents = snapshot.data;
            return StreamBuilder<List<Person>>(
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
                        itemBuilder: (context, friend) => _buildFriendCard(
                          context,
                          person: friend,
                          model: model,
                        ),
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

  Widget _buildFriendCard(
    BuildContext context, {
    @required Person person,
    @required MyFriendsPageModel model,
  }) {
    return Slidable(
      key: Key("slidable-${person.id}"),
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      controller: _silableController,
      actionExtentRatio: 0.18,
      child: Builder(builder: (context) {
        return Container(
          child: FriendListTile(
            backgroundImage: NetworkImage(person.imageUrl),
            model: model,
            person: person,
            onTap: () async {
              Slidable.of(context)?.open();
              Slidable.of(context)?.close();

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FriendPage.create(
                    context,
                    person: person,
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
          onTap: () => SetPersonForm.create(
            context,
            person: person,
            firebaseStorage: model.friendStorage,
            mainPage: widget,
          ),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteFriend(context, person),
        ),
      ],
    );
  }
}
