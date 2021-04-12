import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/loading_screen.dart';
import 'package:bonobo/ui/common_widgets/profile_page/profile_page.dart';
import 'package:bonobo/ui/models/person.dart';
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
    @required this.person,
    @required this.allSpecialEvents,
  }) : super(key: key);

  final Person person;
  final List<SpecialEvent> allSpecialEvents;

  static Widget create(BuildContext context, {@required Person person}) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<SpecialEvent>>(
      stream: database.specialEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FriendPage(person: person, allSpecialEvents: snapshot.data);
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
        widget.person, widget.allSpecialEvents);

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
      appBar: AppBar(title: Text(widget.person.name)),
      body: ProfilePage(
        database: database,
        title: widget.person.name,
        rangeSliderCallBack: (values) => setState(() {
          sliderValues = values;
        }),
        profileImage: NetworkImage(widget.person.imageUrl),
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
                    person: widget.person,
                    eventType: getEventType(tab.text),
                  ),
                  gender: widget.person.gender,
                  database: database,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
