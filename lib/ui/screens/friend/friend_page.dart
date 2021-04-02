import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/profile_page/profile_page.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/products_grid.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class FriendPage extends StatefulWidget {
  FriendPage({
    Key key,
    @required this.friend,
    @required this.friendSpecialEvents,
    @required this.database,
  }) : super(key: key);

  final Friend friend;
  final List<SpecialEvent> friendSpecialEvents;
  final FirestoreDatabase database;

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  RangeValues sliderValues = RangeValues(0, 100);
  List<Tab> myTabs = [];

  @override
  void initState() {
    super.initState();

    widget.friendSpecialEvents.forEach((event) {
      myTabs.add(Tab(text: event.name));
    });

    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friend.name)),
      body: ProfilePage(
        database: widget.database,
        title: widget.friend.name,
        rangeSliderCallBack: (values) => setState(() {
          sliderValues = values;
        }),
        profileImage: NetworkImage(widget.friend.imageUrl),
        sliverTabs: SliverToBoxAdapter(
          child: Container(
            height: 35,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: [
                for (var event in widget.friendSpecialEvents)
                  Container(width: 100, child: Tab(text: event.name)),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              indicator: RectangularIndicator(
                topLeftRadius: 100,
                topRightRadius: 100,
                bottomLeftRadius: 100,
                bottomRightRadius: 100,
                color: Colors.deepPurpleAccent,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: [
              for (var tab in myTabs)
                ProductsGridView(
                  sliderValues: sliderValues,
                  productStream: widget.database.queryFriendProductsStream(
                    friend: widget.friend,
                    eventType: getEventType(tab.text),
                  ),
                  gender: widget.friend.gender,
                  database: widget.database,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
