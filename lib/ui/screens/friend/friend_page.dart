import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/custom_app_bar.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/profile_page/profile_page.dart';
import 'package:bonobo/ui/models/friend.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/products_grid.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class FriendPage extends StatefulWidget {
  FriendPage({
    Key key,
    @required this.friend,
    @required this.allSpecialEvents,
  }) : super(key: key);

  final Friend friend;
  final List<SpecialEvent> allSpecialEvents;

  static Widget create(BuildContext context, {@required Friend friend}) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<SpecialEvent>>(
      stream: database.specialEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FriendPage(friend: friend, allSpecialEvents: snapshot.data);
        }
        return LoadingScreen();
      },
    );
  }

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  RangeValues sliderValues = RangeValues(0, 100);
  List<Tab> myTabs = [];
  List<SpecialEvent> friendSpecialEvents = [];

  @override
  void initState() {
    super.initState();

    friendSpecialEvents = FriendSpecialEvents.getFriendSpecialEvents(
        widget.friend, widget.allSpecialEvents);

    friendSpecialEvents.forEach((event) {
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
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      body: ProfilePage(
        dismissableAppBar: CustomAppBar(
          isDismissable: true,
          height: 80,
          title: Text(
            widget.friend.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom:
                  Radius.elliptical(MediaQuery.of(context).size.width, 100.0),
            ),
          ),
        ),
        database: database,
        title: widget.friend.name,
        rangeSliderCallBack: (values) => setState(() {
          sliderValues = values;
        }),
        sliverTabs: SliverToBoxAdapter(
          child: Container(
            height: 35,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: [
                for (var event in friendSpecialEvents)
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
                  productStream: database.queryFriendProductsStream(
                    friend: widget.friend,
                    eventType: getEventType(tab.text),
                  ),
                  gender: widget.friend.gender,
                  database: database,
                  eventType: getEventType(tab.text),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
