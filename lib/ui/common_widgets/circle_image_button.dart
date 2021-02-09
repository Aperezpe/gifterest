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
    return Container(
      height: 60,
      width: 60,
      child: InkWell(
        key: key,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            imagePath,
            fit: BoxFit.fitHeight,
          ),
        ),
        onTap: onPressed,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
