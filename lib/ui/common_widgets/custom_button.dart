import 'package:auto_size_text/auto_size_text.dart';
import 'package:gifterest/resize/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    this.key,
    @required this.text,
    this.color,
    this.disableColor,
    this.textColor,
    @required this.onPressed,
    this.height: 50,
    this.width: 350,
    this.padding,
    this.borderRadius: 50,
    this.textSize,
  }) : super(key: key);

  final Key key;
  final String text;
  final Color color;
  final Color textColor;
  final Color disableColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final EdgeInsets padding;
  final double borderRadius;
  double textSize;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    textSize = textSize ?? SizeConfig.h3Size;
    double letterSpacing = SizeConfig.safeBlockHorizontal / 5;
    String fontFamily = 'Poppins';
    if (SizeConfig.screenWidth >= 700) {
      textSize = SizeConfig.safeBlockVertical * 2.2;
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: AutoSizeText(
        text.toUpperCase(),
        stepGranularity: 1,
        maxLines: 1,
        style: TextStyle(
          fontSize: textSize,
          letterSpacing: letterSpacing,
          color: textColor,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.pressed))
              return color;
            else if (states.contains(MaterialState.disabled))
              return Colors.grey;
            return color;
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsets>(
          (states) => padding != null
              ? padding
              : EdgeInsets.all(SizeConfig.blockSizeVertical * 1.7),
        ),
        shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        elevation: MaterialStateProperty.resolveWith<double>((states) => 5),
      ),
    );
  }
}
