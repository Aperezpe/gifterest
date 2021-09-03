import 'package:gifterest/ui/common_widgets/platform_widget.dart';
import 'package:gifterest/ui/screens/my_friends/widgets/ios_date_picker.dart';
import 'package:flutter/material.dart';

typedef DropdownButtonBuilder<T> = Widget Function(T selectedValue);

class PlatformDatePicker extends PlatformWidget {
  PlatformDatePicker({
    this.selectedDate,
    this.selectDate,
    this.initialDate,
    this.dropdownButton,
  });

  final DateTime initialDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final DropdownButtonBuilder<DateTime> dropdownButton;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return IOSDatePicker(
      initialDate: initialDate,
      selectedDate: selectedDate,
      selectDate: selectDate,
      dropdownButton: dropdownButton,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return IOSDatePicker(
      initialDate: initialDate,
      selectedDate: selectedDate,
      selectDate: selectDate,
      dropdownButton: dropdownButton,
    );
  }
}
