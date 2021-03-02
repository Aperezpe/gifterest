import 'package:bonobo/ui/common_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'android_dropdown.dart';
import 'cupertino_dropdown.dart';

class PlatformDropdown extends PlatformWidget {
  PlatformDropdown({
    this.onChanged,
    @required this.initialValue,
    @required this.values,
    this.title,
  });

  final String title;
  final String initialValue;
  final List<String> values;
  final ValueChanged<int> onChanged;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDropdown(
      initialValue: initialValue,
      values: values,
      onChanged: onChanged,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AndroidDropdown(
      initialValue: initialValue,
      values: values,
      onChanged: onChanged,
      title: title,
    );
  }
}
