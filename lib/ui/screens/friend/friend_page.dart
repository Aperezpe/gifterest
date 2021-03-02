import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/screens/friend/widgets/products_grid.dart';
import 'package:bonobo/ui/screens/friend/widgets/range_slider.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/friend_page_model.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key key, @required this.model}) : super(key: key);
  final FriendPageModel model;

  static Future<void> show(
    BuildContext context, {
    @required Friend friend,
    @required List<SpecialEvent> friendSpecialEvents,
    @required FirestoreDatabase database,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChangeNotifierProvider<FriendPageModel>(
          create: (context) => FriendPageModel(
            database: database,
            friend: friend,
            friendSpecialEvents: friendSpecialEvents,
          ),
          child: Consumer<FriendPageModel>(
            builder: (context, model, __) => FriendPage(
              model: model,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  Friend get friend => widget.model.friend;

  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    super.initState();
    myTabs = <Tab>[
      Tab(text: "All"),
      for (var event in widget.model.friendSpecialEvents) Tab(text: event.name),
    ];
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: CircleAvatar(
                  radius: 61,
                  backgroundColor: Colors.grey[300],
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(friend.imageUrl),
                  ),
                ),
              ),
            ),
            BudgetSlider(model: widget.model),
            Container(
              height: 80,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                tabs: myTabs,
                labelColor: Colors.black,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (var tab in myTabs)
                    ProductsGridView.create(
                      friend: friend,
                      database: widget.model.database,
                      eventType: getEventType(tab.text),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
