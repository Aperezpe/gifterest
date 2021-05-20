import 'package:bonobo/resize/layout_info.dart';
import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/services/locator.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key key,
    this.title,
    this.actions,
    this.leading,
    this.shape,
    this.height,
    this.isDismissable: false,
  })  : preferredSize = Size.fromHeight(locator.get<LayoutInfo>().appBarHeight),
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

    // Add some RIGHT padding to given actions
    final _actions = actions != null
        ? actions
            .map(
              (action) => Padding(
                child: action,
                padding: EdgeInsets.only(
                  right: is700Wide ? SizeConfig.safeBlockVertical : 0,
                ),
              ),
            )
            .toList()
        : null;

    if (isDismissable) {
      return SliverAppBar(
        toolbarHeight: is700Wide
            ? locator.get<LayoutInfo>().appBarHeight * 1.2
            : locator.get<LayoutInfo>().appBarHeight * 1.5,
        pinned: false,
        snap: false,
        leading: Padding(
          padding: EdgeInsets.only(
            left: is700Wide ? SizeConfig.safeBlockVertical : 0,
          ),
          child: leading,
        ),
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
                  fontSize: is700Wide
                      ? SizeConfig.safeBlockVertical * 2.8
                      : SizeConfig.safeBlockVertical * 3.3,
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
        toolbarHeight: height ?? locator.get<LayoutInfo>().appBarHeight,
        leading: Padding(
          padding: EdgeInsets.only(left: SizeConfig.safeBlockVertical),
          child: leading,
        ),
        flexibleSpace: Container(
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
