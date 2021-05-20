import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  AppBarButton({Key key, this.onTap, this.icon}) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    return GestureDetector(
      child: Icon(
        icon,
        size: is700Wide
            ? SizeConfig.safeBlockVertical * 2.8
            : SizeConfig.safeBlockVertical * 3.3,
      ),
      onTap: onTap,
    );
  }
}
