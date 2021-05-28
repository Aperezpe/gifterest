import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  AppBarButton({
    Key key,
    this.onTap,
    this.icon,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final IconData icon;
  final EdgeInsets padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    return Container(
      padding: padding,
      child: GestureDetector(
        child: Icon(
          icon,
          size: is700Wide
              ? SizeConfig.safeBlockVertical * 3
              : SizeConfig.safeBlockVertical * 3.5,
        ),
        onTap: onTap,
      ),
    );
  }
}
