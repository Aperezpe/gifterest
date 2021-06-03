import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Center(
          child: LoadingBouncingGrid.circle(backgroundColor: Colors.pink),
        ),
      ),
    );
  }
}
