import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_dropdown_button.dart';

class CupertinoDropdown extends StatefulWidget {
  final List<String> values;
  final String initialValue;
  final ValueChanged<int> onChanged;

  CupertinoDropdown({
    Key key,
    this.values,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _CupertinoDropdownState createState() => _CupertinoDropdownState();
}

class _CupertinoDropdownState extends State<CupertinoDropdown> {
  String selectedValue;
  FixedExtentScrollController _scrollController;

  @override
  void initState() {
    selectedValue = widget.initialValue;
    _scrollController = FixedExtentScrollController(
        initialItem: widget.values.indexOf(selectedValue));
    super.initState();
  }

  void _onDone() {
    setState(() {
      int selectedIndex = _scrollController.selectedItem;
      selectedValue = widget.values[selectedIndex];
      _scrollController =
          FixedExtentScrollController(initialItem: selectedIndex);
      widget.onChanged(selectedIndex);
      Navigator.pop(context);
    });
  }

  void _onChanged(int index) {
    setState(() {
      int selectedIndex = _scrollController.selectedItem;
      selectedValue = widget.values[selectedIndex];
      widget.onChanged(selectedIndex);
    });
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacer(flex: 4),
                      Flexible(
                        flex: 1,
                        child: CupertinoDialogAction(
                          child: Text("Done"),
                          isDefaultAction: true,
                          onPressed: _onDone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: _onChanged,
                  scrollController: _scrollController,
                  itemExtent: 35.0,
                  children: [
                    for (String v in widget.values) Center(child: Text(v)),
                  ],
                ),
              ),
            ],
          ),
        );
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
