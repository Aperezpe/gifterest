import 'package:gifterest/resize/size_config.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {Key key, @required this.items, @required this.itemBuilder})
      : super(key: key);
  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _buildList(items);
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      padding: EdgeInsets.fromLTRB(
        SizeConfig.safeBlockHorizontal * 2,
        0,
        SizeConfig.safeBlockHorizontal * 2,
        0,
      ),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
