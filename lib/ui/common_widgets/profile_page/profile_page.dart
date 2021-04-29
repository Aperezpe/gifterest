import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/common_widgets/profile_page/widgets/custom_range_slider.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
    @required this.database,
    @required this.title,
    @required this.rangeSliderCallBack,
    this.dismissableAppBar,
    this.sliverTabs,
    this.body,
  }) : super(key: key);

  final FirestoreDatabase database;
  final String title;
  final ValueChanged<RangeValues> rangeSliderCallBack;
  final SliverToBoxAdapter sliverTabs;
  final Widget body;
  final Widget dismissableAppBar;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  RangeValues rangeValues = RangeValues(0, 100);

  ScrollController _scrollController;
  Widget _sliverTabs;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.sliverTabs == null) {
      _sliverTabs = SliverToBoxAdapter();
    } else {
      _sliverTabs = widget.sliverTabs;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            if (widget.dismissableAppBar != null) widget.dismissableAppBar,
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    CustomRangeSlider(onChanged: widget.rangeSliderCallBack),
                  ],
                ),
              ),
            ),
            _sliverTabs,
          ];
        },
        body: widget.body,
      ),
    );
  }
}
