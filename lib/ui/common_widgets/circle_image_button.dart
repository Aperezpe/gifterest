import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleImageButton extends StatelessWidget {
  CircleImageButton({
    this.text,
    this.textColor,
    this.color,
    @required this.onPressed,
  });

  final String text;
  final Color textColor;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 24,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
