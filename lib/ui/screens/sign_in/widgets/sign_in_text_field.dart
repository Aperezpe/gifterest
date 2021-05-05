import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SignInTextField extends StatelessWidget {
  SignInTextField({
    this.key,
    @required this.controller,
    this.hintText = "",
    this.icon,
    this.textInputAction,
    this.onEditingComplete,
    this.obscureText = false,
    this.errorText = '',
    @required this.focusNode,
    @required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  final Key key;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputAction textInputAction;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final String errorText;
  final bool enabled;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double iconSize = SizeConfig.safeBlockVertical * 4.3;
    double textSize = SizeConfig.safeBlockHorizontal * 4.5;
    String fontFamily = 'Mulish';
    if (SizeConfig.screenWidth >= 700) {
      iconSize = SizeConfig.safeBlockVertical * 3.2;
      textSize = SizeConfig.safeBlockVertical * 2;
    }

    return TextField(
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.safeBlockHorizontal * 4,
            right: SizeConfig.safeBlockHorizontal * 2,
            top: SizeConfig.blockSizeVertical * 2,
            bottom: SizeConfig.blockSizeVertical * 2,
          ),
          child: Icon(
            icon,
            size: iconSize,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: textSize,
          fontFamily: fontFamily,
        ),
        fillColor: Color(0xffEAEAEA),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        errorText: errorText,
        enabled: enabled,
      ),
      style: TextStyle(
        fontSize: textSize,
        fontFamily: fontFamily,
      ),
      obscureText: obscureText,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
