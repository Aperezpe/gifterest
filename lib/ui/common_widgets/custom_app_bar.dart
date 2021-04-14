import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key key,
    this.title,
    this.actions,
    this.leading,
    this.shape,
    this.height = 60,
    this.isDismissable: false,
  })  : preferredSize = Size.fromHeight(height),
        super(key: key);

  @override
  final Size preferredSize;
  final double height;
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final ShapeBorder shape;
  final bool isDismissable;

  @override
  Widget build(BuildContext context) {
    if (isDismissable) {
      return SliverAppBar(
        expandedHeight: height,
        pinned: false,
        snap: false,
        floating: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.pink],
              stops: [0.3, 1.0],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink[100],
                offset: Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
            borderRadius: shape != null
                ? BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      50.0,
                    ),
                  )
                : BorderRadius.zero,
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: title,
            ),
          ),
        ),
        actions: actions,
        shape: shape,
        shadowColor: Colors.pink,
        brightness: Brightness.dark,
        elevation: 5,
      );
    } else {
      return AppBar(
        leading: leading,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.pink],
              stops: [0.3, 1.0],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: shape != null
                ? BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0),
                  )
                : BorderRadius.zero,
          ),
        ),
        title: title,
        actions: actions,
        shape: shape,
        shadowColor: Colors.pink,
        brightness: Brightness.dark,
        elevation: 5,
      );
    }
  }
}
