import 'package:bonobo/ui/common_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends PlatformWidget {
  PlatformSwitch({this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.teal[500],
    );
  }
}
