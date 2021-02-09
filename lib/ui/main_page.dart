import 'package:bonobo/ui/cupertino_main_scaffold.dart';
import 'package:bonobo/ui/screens/home/home_page.dart';
import 'package:bonobo/ui/screens/my_friends/my_friends_page.dart';
import 'package:bonobo/ui/tab_item.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key, this.auth, this.database}) : super(key: key);

  final auth;
  final database;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TabItem _currentTab = TabItem.home;

  Map<TabItem, WidgetBuilder> get widgetBuilder {
    return {
      TabItem.home: (_) => HomePage(),
      TabItem.myFriends: (_) =>
          MyFriendsPage.create(auth: widget.auth, database: widget.database),
      TabItem.calendar: (_) => Container(),
      TabItem.favorites: (_) => Container(),
    };
  }

  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoMainScaffold(
      currentTab: _currentTab,
      onSelectedTab: _select,
      widgetBuilder: widgetBuilder,
    );
  }
}
