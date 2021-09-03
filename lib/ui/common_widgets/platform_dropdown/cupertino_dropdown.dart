import 'package:gifterest/resize/size_config.dart';
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
    final is800Hight = SizeConfig.screenHeight >= 800;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: is700Wide
                      ? SizeConfig.safeBlockHorizontal * 12
                      : SizeConfig.safeBlockHorizontal * 18,
                  child: CupertinoDialogAction(
                    textStyle: TextStyle(
                      fontSize: is800Hight
                          ? SizeConfig.safeBlockVertical * 2.3
                          : SizeConfig.safeBlockVertical * 3.2,
                    ),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: SizeConfig.h4Size,
                      ),
                    ),
                    isDefaultAction: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 30,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: SizeConfig.h3Size,
                      ),
                    ),
                  ),
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: _onChanged,
                    scrollController: _scrollController,
                    itemExtent: is700Wide
                        ? SizeConfig.safeBlockVertical * 4.7
                        : SizeConfig.safeBlockVertical * 5,
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
