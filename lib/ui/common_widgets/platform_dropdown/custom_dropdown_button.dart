import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String selectedValue;

  const CustomDropdownButton({Key key, this.selectedValue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 2),
            ),
          ]),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockVertical * 2.5,
        vertical: SizeConfig.safeBlockVertical * 2.5,
      ),
      child: Row(
        children: [
          Text(
            selectedValue,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.subtitleSize,
            ),
          ),
          Spacer(),
          Icon(
            Icons.expand_more,
            size: SizeConfig.safeBlockVertical * 3,
          ),
        ],
      ),
    );
  }
}
