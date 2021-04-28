import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    this.key,
    @required this.text,
    this.colors,
    this.textColor,
    @required this.onPressed,
    this.height: 50,
    this.width: 350,
    this.padding,
    this.gradient,
  }) : super(key: key);

  final Key key;
  final String text;
  final List<Color> colors;
  final Color textColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final EdgeInsets padding;
  final Gradient gradient;

  final double blurRadius = 8;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Color(0xff001AFF).withOpacity(.38),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: height,
          ),
          alignment: Alignment.center,
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        padding: EdgeInsets.all(blurRadius + 2),
      ),
    );
  }
}
