import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    @required this.text,
    this.color,
    this.disableColor,
    this.textColor,
    @required this.onPressed,
    this.height: 50,
    this.width: 350,
  });

  final String text;
  final Color color;
  final Color textColor;
  final Color disableColor;
  final VoidCallback onPressed;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: SizedBox.expand(
        child: RaisedButton(
          color: color,
          disabledColor: disableColor,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
