import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DrawerButtonBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Builder(
      builder: (context) {
        return IconButton(
          icon: Icon(
            LineIcons.bars,
            size: is700Wide
                ? SizeConfig.safeBlockVertical * 3
                : SizeConfig.safeBlockVertical * 4,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    );
  }
}
