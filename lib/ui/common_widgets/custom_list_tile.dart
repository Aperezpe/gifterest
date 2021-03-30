import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({this.title, this.icon, this.iconColor, this.onTap});

  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[400]))),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
