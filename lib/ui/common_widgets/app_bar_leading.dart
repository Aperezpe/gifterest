import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class LeadingButton extends StatelessWidget {
  LeadingButton({Key key, this.onTap, this.icon}) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      child: Icon(
        icon,
        size: SizeConfig.safeBlockVertical * 2.8,
      ),
      onTap: onTap,
    );
  }
}
