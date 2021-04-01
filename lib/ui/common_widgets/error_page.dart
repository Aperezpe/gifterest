import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage(this.error);

  final error;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("$error"),
      ),
    );
  }
}
