import 'package:bonobo/ui/common_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends PlatformWidget {
  PlatformSwitch(
      {this.value, this.onChanged, this.activeColor, this.trackColor});

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color trackColor;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      trackColor: trackColor,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      activeTrackColor: trackColor,
    );
  }
}
