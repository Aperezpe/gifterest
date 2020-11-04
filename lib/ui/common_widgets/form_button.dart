import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class BonoboFormButton extends StatelessWidget {
  String _text;
  Function _onPressed;

  BonoboFormButton({text, onPressed}) {
    _text = text;
    _onPressed = onPressed;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      width: SizeConfig.screenWidth,
      child: RaisedButton(
        elevation: SizeConfig.safeBlockVertical * 1,
        padding: EdgeInsets.fromLTRB(
          SizeConfig.blockSizeHorizontal * 12,
          SizeConfig.blockSizeHorizontal * 3,
          SizeConfig.blockSizeHorizontal * 12,
          SizeConfig.blockSizeHorizontal * 3,
        ),
        color: Color(0xffFF3969),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          SizeConfig.blockSizeVertical * 15,
        )),
        onPressed: _onPressed,
        child: Text(
          _text,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.safeBlockVertical * 3.25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
