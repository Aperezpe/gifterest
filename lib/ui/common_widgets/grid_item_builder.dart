import 'package:flutter/material.dart';

import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);
// typedef FilterList(List<dynamic> items, dynamic filters);

// enum ListType {
//   products,
//   interests,
// }

class GridItemBuilder<T> extends StatelessWidget {
  const GridItemBuilder({
    @required this.snapshot,
    @required this.itemBuilder,
    this.padding,
    this.crossAxisCount: 2,
    // this.filterFunction,
    this.shrinkWrap: false,
    this.primary: true,
    this.childAspectRatio: 1.0,
    this.filters,
    // this.listType,
  });

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  // final FilterList filterFunction;
  final EdgeInsets padding;
  final int crossAxisCount;
  final bool shrinkWrap;
  final bool primary;
  final double childAspectRatio;
  final dynamic filters;
  // final ListType listType;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      List<T> items = snapshot.data;
      // if (filterFunction != null) {
      //   items = filterFunction(items, filters);
      // }
      if (items.isNotEmpty) {
        return _buildGrid(items);
      } else {
        return Container();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildGrid(List<T> items) {
    return GridView.builder(
      padding: padding,
      itemCount: items.length,
      shrinkWrap: shrinkWrap,
      primary: primary,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, childAspectRatio: childAspectRatio),
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}
