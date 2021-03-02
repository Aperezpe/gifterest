import 'package:bonobo/ui/common_widgets/platform_widget.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/android_date_picker.dart';
import 'package:bonobo/ui/screens/my_friends/widgets/ios_date_picker.dart';
import 'package:flutter/material.dart';

class PlatformDatePicker extends PlatformWidget {
  PlatformDatePicker({
    this.selectedDate,
    this.selectDate,
    this.initialDate,
  });

  final DateTime initialDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return IOSDatePicker(
      initialDate: initialDate,
      selectedDate: selectedDate,
      selectDate: selectDate,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AndroidDatePicker(
      initialDate: initialDate,
      selectedDate: selectedDate,
      selectDate: selectDate,
    );
  }
}
