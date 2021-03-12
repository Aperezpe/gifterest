import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/screens/friend/widgets/products_grid.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:bonobo/ui/screens/my_friends/models/special_event.dart';
import 'package:bonobo/ui/style/fontStyle.dart';
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
  Friend get friend => widget.friend;

  RangeValues onStartValues;
  RangeValues currentValues;

  ScrollController _scrollController;
  TabController _tabController;
  List<Tab> myTabs;

  @override
  void initState() {
    super.initState();
    onStartValues = RangeValues(0, 100);
    currentValues = onStartValues;

    myTabs = <Tab>[
      // Tab(text: "All"),
      for (var event in widget.friendSpecialEvents) Tab(text: event.name),
    ];
    _tabController = TabController(vsync: this, length: myTabs.length);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
      ),
      body: Container(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
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
                      _buildRangeSlider(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
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
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
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
            ];
          },
          body: Container(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (var tab in myTabs)
                  ProductsGridView.create(
                    friend: friend,
                    database: widget.database,
                    eventType: getEventType(tab.text),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text("Budget", style: h3),
        ),
        Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Row(
            children: [
              Container(
                  width: 25, child: Text("${currentValues.start.round()}")),
              Expanded(
                child: RangeSlider(
                  values: currentValues,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: (values) => setState(() => currentValues = values),
                  onChangeStart: (values) => onStartValues = values,
                  onChangeEnd: _onChangeEnd,
                ),
              ),
              Container(
                width: 40,
                child: currentValues.end == 100
                    ? Text("${currentValues.end.round()}+")
                    : Text("${currentValues.end.round()}"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Prevents rangeValues to be equal
  void _onChangeEnd(RangeValues endValues) {
    setState(
      () {
        if (onStartValues.start != endValues.start) {
          if (endValues.start == endValues.end) {
            currentValues = RangeValues(endValues.start - 10, endValues.end);
          }
        } else if (onStartValues.end != endValues.end) {
          if (endValues.start == endValues.end) {
            currentValues = RangeValues(endValues.start, endValues.end + 10);
          }
        }
      },
    );
  }
}
