import 'package:gifterest/resize/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleImageButton extends StatelessWidget {
  CircleImageButton({
    this.key,
    this.text,
    this.textColor,
    this.color,
    this.borderRadius = 15.0,
    @required this.onPressed,
    @required this.imagePath,
  });

  final Key key;
  final String text;
  final Color textColor;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    return Container(
      height: is700Wide
          ? SizeConfig.safeBlockVertical * 7
          : SizeConfig.safeBlockVertical * 9,
      width: is700Wide
          ? SizeConfig.safeBlockVertical * 7
          : SizeConfig.safeBlockVertical * 9,
      child: InkWell(
        key: key,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
          child: Image.asset(
            imagePath,
            fit: BoxFit.fitHeight,
          ),
        ),
        onTap: onPressed,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
      ),
    );
  }
}
