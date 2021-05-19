import 'package:bonobo/resize/size_config.dart';
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
    final is700Wide = SizeConfig.screenWidth >= 700;
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
                  height: SizeConfig.safeBlockVertical * 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacer(flex: 6),
                      Flexible(
                        flex: 1,
                        child: CupertinoDialogAction(
                          child: Text(
                            "Done",
                            style: TextStyle(
                              fontSize: is700Wide
                                  ? SizeConfig.safeBlockVertical * 2.3
                                  : SizeConfig.safeBlockVertical * 2.8,
                            ),
                          ),
                          isDefaultAction: true,
                          onPressed: _onDone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: is700Wide
                            ? SizeConfig.safeBlockVertical * 2.5
                            : SizeConfig.safeBlockVertical * 2.8,
                      ),
                    ),
                  ),
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: _onChanged,
                    scrollController: _scrollController,
                    itemExtent: is700Wide
                        ? SizeConfig.safeBlockVertical * 4.5
                        : SizeConfig.safeBlockVertical * 4.8,
                    children: [
                      for (String v in widget.values) Center(child: Text(v)),
                    ],
                  ),
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
    SizeConfig().init(context);
    return GestureDetector(
      onTap: _showPicker,
      child: CustomDropdownButton(selectedValue: selectedValue),
    );
  }
}
