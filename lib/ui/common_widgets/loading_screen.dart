import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          color: Colors.white,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
