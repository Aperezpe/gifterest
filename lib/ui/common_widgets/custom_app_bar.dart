import 'package:bonobo/resize/size_config.dart';
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
  final String title;
  final List<Widget> actions;
  final Widget leading;
  final ShapeBorder shape;
  final bool isDismissable;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    final _actions = actions != null
        ? actions
            .map(
              (action) => Padding(
                  child: action,
                  padding:
                      EdgeInsets.only(right: SizeConfig.safeBlockVertical)),
            )
            .toList()
        : null;

    if (isDismissable) {
      return SliverAppBar(
        expandedHeight: height,
        toolbarHeight: height,
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
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        actions: _actions,
        shape: shape,
        shadowColor: Colors.pink,
        brightness: Brightness.dark,
        elevation: 5,
      );
    } else {
      return AppBar(
        toolbarHeight: height,
        leading: Padding(
          padding: EdgeInsets.only(left: SizeConfig.safeBlockVertical),
          child: leading,
        ),
        flexibleSpace: Container(
          height: height,
          padding: EdgeInsets.only(top: 500),
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
        title: Text(
          title,
          style: TextStyle(
            fontSize: is700Wide
                ? SizeConfig.safeBlockVertical * 3
                : SizeConfig.safeBlockVertical * 3.5,
            fontFamily: 'Nunito-Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _actions,
        shape: shape,
        shadowColor: Colors.pink,
        brightness: Brightness.dark,
        elevation: 5,
      );
    }
  }
}
