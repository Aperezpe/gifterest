import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({this.isGray: false});

  final isGray;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: isGray ? Colors.black.withOpacity(0.5) : Colors.white,
        child: Center(
          child: LoadingBouncingGrid.circle(backgroundColor: Colors.pink),
        ),
      ),
    );
  }
}
