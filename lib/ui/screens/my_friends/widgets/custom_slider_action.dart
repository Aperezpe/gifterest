import 'package:flutter/material.dart';

enum SliderActionType {
  right,
  left,
}

class CustomSliderAction extends StatelessWidget {
  const CustomSliderAction({
    Key key,
    this.text,
    this.actionType,
    this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  final String text;
  final SliderActionType actionType;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: actionType == SliderActionType.left
              ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
