import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String selectedValue;

  const CustomDropdownButton({Key key, this.selectedValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 2),
            ),
          ]),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            selectedValue,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Spacer(),
          Icon(Icons.expand_more),
        ],
      ),
    );
  }
}
