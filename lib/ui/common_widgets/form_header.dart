import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class FormHeader extends StatefulWidget {
  @override
  _FormHeaderState createState() => _FormHeaderState();
}

class _FormHeaderState extends State<FormHeader> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              SizeConfig.blockSizeVertical * 3,
            ),
            child: Image.asset(
              "assets/bonobo_logo.png",
              height: SizeConfig.safeBlockVertical * 14,
              width: SizeConfig.safeBlockVertical * 14,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
          child: Text(
            "BONOBO",
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.safeBlockVertical * 4,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 2,
            bottom: SizeConfig.blockSizeVertical * 4,
          ),
          child: Text(
            "Event reminders and customized gift suggestions to strengthen your most precious relationships.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              fontWeight: FontWeight.w300,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
