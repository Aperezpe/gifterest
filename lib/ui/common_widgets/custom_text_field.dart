import 'package:gifterest/resize/size_config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.key,
    this.focusNode,
    this.labelText = "",
    this.icon,
    this.textInputAction,
    this.validator,
    this.initialValue,
    this.onEditingComplete,
    this.obscureText = false,
    this.errorText = '',
    @required this.onChanged,
    this.enabled = true,
    this.onSaved,
    this.keyboardType,
  }) : super(key: key);

  final FocusNode focusNode;
  final Key key;
  final String initialValue;
  final String labelText;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final IconData icon;
  final FormFieldSetter<String> onSaved;
  final TextInputAction textInputAction;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final String errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    return TextFormField(
      key: key,
      focusNode: focusNode,
      initialValue: initialValue,
      decoration: new InputDecoration(
        labelText: labelText,
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: SizeConfig.subtitleSize,
        ),
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(SizeConfig.safeBlockVertical),
          borderSide: new BorderSide(),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockVertical * 2.5,
          vertical: SizeConfig.safeBlockVertical * 2.5,
        ),
      ),
      validator: validator,
      obscureText: obscureText,
      autocorrect: false,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: TextStyle(
        fontSize: SizeConfig.subtitleSize,
      ),
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
