import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class BonoboTextFormField extends StatelessWidget {
  String _hintText;
  IconData _icon;
  bool _isPassword;
  TextEditingController _inputController;

  BonoboTextFormField({hintText, icon, isPassword, controller}) {
    _hintText = hintText;
    _icon = icon;
    _isPassword = isPassword;
    _inputController = controller;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return TextField(
      obscureText: _isPassword ? true : false,
      controller: _inputController,
      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.25),
      decoration: InputDecoration(
        hintText: _hintText,
        filled: true,
        fillColor: Color(0xffEAEAEA),
        contentPadding: EdgeInsets.all(
          SizeConfig.blockSizeVertical * 2,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 14.0),
          child: Icon(
            _icon,
            size: SizeConfig.blockSizeVertical * 3.75,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockVertical * 12,
          ),
          borderSide: BorderSide(color: Color(0xffEAEAEA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockVertical * 12,
          ),
          borderSide: BorderSide(color: Color(0xffFF3969)),
        ),
      ),
    );
  }
}
