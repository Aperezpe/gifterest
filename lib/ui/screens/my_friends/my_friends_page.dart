import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/empty_content.dart';
import 'package:bonobo/ui/common_widgets/error_page.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/platform_alert_dialog.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/custom_slider_action.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'models/special_event.dart';

// TODO: Sacar un snackbar o hacer highlight el friend que acaban de hacer update
// TODO: Add animation to delete items https://github.com/mobiten/flutter_staggered_animations/issues/13
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

  void _addNewFriend() {
    SetPersonForm.create(
      context,
      mainPage: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: Text("My Friends"),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 28,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          onPressed: _addNewFriend,
        ),
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
                      return friends.isEmpty
                          ? EmptyContent(
                              assetPath: 'assets/sad_monkey.jpg',
                              title: "Friends Not Found",
                              message:
                                  "Looks like you havent added any friends yet",
                              bottomWidget: CustomButton(
                                onPressed: _addNewFriend,
                                text: "Add Friend",
                                padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                                color: Colors.blue,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: ListItemsBuilder(
                                items: model.friends,
                                itemBuilder: (context, friend) =>
                                    _buildFriendCard(
                                  context,
                                  person: friend,
                                  model: model,
                                ),
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
        return FriendListTile(
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
        );
      }),
      secondaryActions: <Widget>[
        CustomSliderAction(
          text: 'Edit',
          icon: Icons.edit,
          color: Colors.blue,
          actionType: SliderActionType.left,
          onTap: () => SetPersonForm.create(
            context,
            person: person,
            mainPage: widget,
          ),
        ),
        CustomSliderAction(
          text: 'Delete',
          icon: Icons.delete,
          color: Colors.redAccent,
          actionType: SliderActionType.right,
          onTap: () => _deleteFriend(context, person),
        ),
      ],
    );
  }
}
