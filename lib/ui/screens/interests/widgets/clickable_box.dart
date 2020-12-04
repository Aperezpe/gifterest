import 'package:bonobo/ui/models/interest.dart';
import 'package:flutter/material.dart';

class ClickableInterest extends StatelessWidget {
  ClickableInterest({
    this.interest,
    this.onTap,
    this.color,
  });

  final Interest interest;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 8.0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/naruto.png'), // interest.imageUrl
            Text(
              interest.nameId,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
