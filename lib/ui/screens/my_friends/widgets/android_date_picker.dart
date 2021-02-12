import 'dart:async';

import 'package:bonobo/ui/common_widgets/platform_dropdown/custom_dropdown_button.dart';
import 'package:flutter/material.dart';
import '../format.dart';

class AndroidDatePicker extends StatelessWidget {
  const AndroidDatePicker({
    Key key,
    this.labelText,
    @required this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      selectDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: CustomDropdownButton(
              selectedValue: Format.date(selectedDate),
            ),
          ),
        ),
      ],
    );
  }
}
