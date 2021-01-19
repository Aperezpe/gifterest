import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleImageButton extends StatelessWidget {
  CircleImageButton({
    this.text,
    this.textColor,
    this.color,
    @required this.onPressed,
    @required this.imagePath,
  });

  final String text;
  final Color textColor;
  final Color color;
  final VoidCallback onPressed;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
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
