import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    this.key,
    @required this.text,
    this.textColor,
    @required this.onPressed,
    this.height: 50,
    this.width: 350,
    this.padding,
    this.textSize = 20,
    @required this.gradient,
    this.shadowColor = Colors.grey,
  }) : super(key: key);

  final Key key;
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final EdgeInsets padding;
  final Gradient gradient;
  final Color shadowColor;
  final double textSize;

  final double blurRadius = 8;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ElevatedButton(
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: EdgeInsets.all(blurRadius + 2),
      ),
    );
  }
}
