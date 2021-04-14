import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

import 'custom_dropdown_button.dart';

class AndroidDropdown extends StatefulWidget {
  final String initialValue;
  final List<String> values;
  final ValueChanged<int> onChanged;
  final String title;

  AndroidDropdown({
    Key key,
    @required this.initialValue,
    this.values,
    @required this.onChanged,
    this.title,
  }) : super(key: key);
  @override
  _AndroidDropdownState createState() => _AndroidDropdownState();
}

class _AndroidDropdownState extends State<AndroidDropdown> {
  String selectedValue;

  @override
  void initState() {
    selectedValue = widget.initialValue;

    super.initState();
  }

  void _showPicker() {
    showMaterialRadioPicker(
      context: context,
      title: widget.title,
      items: widget.values,
      selectedValue: selectedValue,
      onChanged: (value) {
        setState(() {
          widget.onChanged(widget.values.indexOf(value));
          selectedValue = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPicker,
      child: CustomDropdownButton(selectedValue: selectedValue),
    );
  }
}
