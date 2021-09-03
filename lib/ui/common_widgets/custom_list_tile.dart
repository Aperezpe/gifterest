import 'package:gifterest/resize/size_config.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({this.title, this.icon, this.iconColor, this.onTap});

  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    final leftPadding = is700Wide
        ? SizeConfig.safeBlockHorizontal * 2
        : SizeConfig.safeBlockHorizontal * 3;

    final tileHeight = is700Wide
        ? SizeConfig.safeBlockVertical * 6
        : SizeConfig.safeBlockVertical * 8;

    final iconSize = is700Wide
        ? SizeConfig.safeBlockHorizontal * 4
        : SizeConfig.safeBlockHorizontal * 7;

    final textSize = SizeConfig.h3Size;

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[400]))),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(
            left: leftPadding,
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: iconSize),
                    SizedBox(width: iconSize / 2, height: tileHeight),
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: textSize,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
