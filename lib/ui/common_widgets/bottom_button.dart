import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class BottomButton extends StatelessWidget {
  BottomButton({
    @required this.text,
    this.color,
    this.disableColor,
    this.textColor,
    @required this.onPressed,
    this.padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
  });

  final String text;
  final Color color;
  final Color textColor;
  final Color disableColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white12],
          stops: [0.5, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      width: double.infinity,
      padding: padding,
      child: CustomButton(
        onPressed: onPressed,
        text: text,
        disableColor: disableColor,
        textColor: textColor,
        color: color,
      ),
    );
  }
}
