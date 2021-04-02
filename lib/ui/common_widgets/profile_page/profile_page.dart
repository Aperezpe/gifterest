import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/custom_range_slider.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
    @required this.database,
    @required this.title,
    @required this.imageUrl,
    @required this.rangeSliderCallBack,
    this.sliverTabs,
    this.body,
  }) : super(key: key);

  final FirestoreDatabase database;
  final String title;
  final String imageUrl;
  final ValueChanged<RangeValues> rangeSliderCallBack;
  final SliverToBoxAdapter sliverTabs;
  final Widget body;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  // I can probably move all this into a mixin
  RangeValues rangeValues = RangeValues(0, 100);

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                              backgroundImage: NetworkImage(widget.imageUrl),
                            ),
                          ),
                        ),
                      ),
                      CustomRangeSlider(onChanged: widget.rangeSliderCallBack),
                    ],
                  ),
                ),
              ),
              widget.sliverTabs,
            ];
          },
          body: widget.body,
        ),
      ),
    );
  }
}
