import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    @required this.text,
    this.color,
    this.disableColor,
    this.textColor,
    @required this.onPressed,
  });

  final String text;
  final Color color;
  final Color textColor;
  final Color disableColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      disabledColor: disableColor,
      padding: EdgeInsets.all(15.0),
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
        borderRadius: BorderRadius.circular(25),
      ),
      onPressed: onPressed,
    );
  }
}
