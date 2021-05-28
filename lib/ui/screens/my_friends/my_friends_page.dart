import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/app_drawer.dart';
import 'package:bonobo/ui/common_widgets/custom_alert_dialog/custom_alert_dialog.dart';
import 'package:bonobo/ui/common_widgets/custom_alert_dialog/responsive_alert_dialogs.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/custom_button.dart';
import 'package:bonobo/ui/common_widgets/drawer_button_builder.dart';
import 'package:bonobo/ui/common_widgets/empty_content.dart';
import 'package:bonobo/ui/common_widgets/error_page.dart';
import 'package:bonobo/ui/common_widgets/list_item_builder.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/set_form/set_form.dart';
import 'package:bonobo/ui/models/friend.dart';
import 'package:bonobo/ui/models/person.dart';
import 'package:bonobo/ui/screens/friend/friend_page.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/custom_slider_action.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/friend_list_tile.dart';
import 'package:bonobo/ui/screens/my_friends/models/my_friends_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:bonobo/extensions/base_colors.dart';

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
  bool _isEmpty;

  void _deleteFriend(BuildContext context, Person friend) async {
    final model = Provider.of<MyFriendsPageModel>(context, listen: false);
    try {
      final yes = await WarningDialog(
        title: "Delete?",
        content: "Are you sure want to delete ${friend.name}?",
        yesButtonText: 'Yes',
        noButtonText: 'Cancel',
      ).show(context);

      if (yes) await model.deleteFriend(friend);
    } catch (e) {
      await ErrorDialog(
        title: "Error",
        content: "Something went wrong",
        yesButtonText: 'Ok',
      ).show(context);
    }
  }

  void _addNewFriend() {
    SetPersonForm.create(
      context,
      mainPage: widget,
    );
  }

  void _openFriendPage(Friend friend) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FriendPage.create(
          context,
          friend: friend,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase database =
        Provider.of<Database>(context, listen: false);

    SizeConfig().init(context);

    return StreamBuilder<List<SpecialEvent>>(
      stream: database.specialEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allSpecialEvents = snapshot.data;
          return StreamBuilder<List<Friend>>(
            stream: database.friendsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final friends = snapshot.data;
                _isEmpty = friends.isEmpty;
                return ChangeNotifierProvider<MyFriendsPageModel>(
                  create: (context) => MyFriendsPageModel(
                    database: database,
                    allSpecialEvents: allSpecialEvents,
                    friends: friends,
                  ),
                  builder: (context, child) {
                    final model =
                        Provider.of<MyFriendsPageModel>(context, listen: false);

                    return _buildContent(friends, model);
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
    );
  }

  Scaffold _buildContent(List<Friend> friends, MyFriendsPageModel model) {
    final is700Wide = SizeConfig.screenWidth >= 700;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "My Friends",
        leading: DrawerButtonBuilder(),
      ),
      drawer: AppDrawer(
        currentChildRouteName: MyFriendsPage.routeName,
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(
          bottom: SizeConfig.safeBlockVertical,
          right: SizeConfig.safeBlockVertical,
        ),
        child: _isEmpty
            ? Container()
            : Container(
                height: SizeConfig.safeBlockVertical * 8,
                width: SizeConfig.safeBlockVertical * 8,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    size: SizeConfig.safeBlockVertical * 4.5,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blue,
                  onPressed: _addNewFriend,
                ),
              ),
      ),
      body: friends.isEmpty
          ? EmptyContent(
              assetPath: 'assets/sad_monkey.jpg',
              title: "Friends Not Found",
              message: "Looks like you havent added any friends yet",
              bottomWidget: CustomButton(
                onPressed: _addNewFriend,
                text: "Add Friend",
                padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                color: Colors.blue,
              ),
            )
          : is700Wide
              ? GridView.builder(
                  padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
                  itemCount: friends.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: is700Wide ? 3 : 2,
                    childAspectRatio: .9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return FriendListTile(
                      onTap: () => _openFriendPage(friend),
                      person: friend,
                      editAction: () => SetPersonForm.create(
                        context,
                        person: friend,
                        mainPage: widget,
                      ),
                      deleteAction: () => _deleteFriend(context, friend),
                      model: model,
                    );
                  },
                )
              : ListItemsBuilder(
                  items: model.friends,
                  itemBuilder: (context, friend) => _buildFriendCard(
                    context,
                    friend: friend,
                    model: model,
                  ),
                ),
    );
  }

  Widget _buildFriendCard(
    BuildContext context, {
    @required Friend friend,
    @required MyFriendsPageModel model,
  }) {
    return Slidable(
      key: Key("slidable-${friend.id}"),
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      controller: _silableController,
      actionExtentRatio: 0.18,
      child: Builder(builder: (context) {
        return FriendListTile(
          model: model,
          person: friend,
          onTap: () async {
            Slidable.of(context)?.open();
            Slidable.of(context)?.close();
            _openFriendPage(friend);
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
            person: friend,
            mainPage: widget,
          ),
        ),
        CustomSliderAction(
          text: 'Delete',
          icon: Icons.delete,
          color: Colors.redAccent,
          actionType: SliderActionType.right,
          onTap: () => _deleteFriend(context, friend),
        ),
      ],
    );
  }
}
