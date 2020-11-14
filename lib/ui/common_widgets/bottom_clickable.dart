import 'package:flutter/material.dart';

class BottomClickable extends StatelessWidget {
  BottomClickable({
    @required this.text,
    this.onTap,
    this.color,
    this.textColor,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.pink,
      elevation: 0,
      child: InkWell(
        splashColor: Colors.pinkAccent,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // child: InkWell(
      //   child: Text(text),
      //   onTap: onTap,
      // ),
    );
  }
}
