import 'package:bonobo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'custom_dropdown_button.dart';

class AndroidDropdown extends StatefulWidget {
  final String initialValue;
  final List<String> values;
  final ValueChanged<int> onChanged;

  AndroidDropdown({
    Key key,
    @required this.initialValue,
    this.values,
    this.onChanged,
  }) : super(key: key);
  @override
  _AndroidDropdownState createState() => _AndroidDropdownState();
}

class _AndroidDropdownState extends State<AndroidDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpen = false;
  OverlayEntry floatingDropdown;
  List<DropDownItem> dropdownItems = [];
  String selectedValue;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.initialValue);
    selectedValue = widget.initialValue;
    for (int i = 0; i < widget.values.length; ++i) {
      int indexOfInitialValue = widget.values.indexOf(selectedValue);
      if (i == indexOfInitialValue) {
        dropdownItems.add(
          DropDownItem(
              text: widget.values[i], onTap: () => _onTap(i), isSelected: true),
        );
      } else {
        dropdownItems.add(
          DropDownItem(text: widget.values[i], onTap: () => _onTap(i)),
        );
      }
    }
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  void _onTap(int itemIndex) {
    List<DropDownItem> tmpItems = [];
    for (int i = 0; i < dropdownItems.length; ++i) {
      if (i == itemIndex) {
        tmpItems.add(
          DropDownItem(
            text: widget.values[i],
            onTap: () => _onTap(i),
            isSelected: true,
          ),
        );
        selectedValue = widget.values[i];
      } else {
        tmpItems.add(
          DropDownItem(
            text: widget.values[i],
            onTap: () => _onTap(i),
            isSelected: false,
          ),
        );
      }
    }
    widget.onChanged(itemIndex);
    setState(() {
      dropdownItems = tmpItems;
    });
    _toggleFloatingBox();
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  floatingDropdown.remove();
                  isDropdownOpen = false;
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              left: xPosition,
              width: width,
              top: yPosition + height,
              height: widget.values.length * height + 5,
              child: DropDownFloatingBox(
                itemHeight: height,
                items: dropdownItems,
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleFloatingBox() {
    setState(() {
      if (isDropdownOpen) {
        floatingDropdown.remove();
      } else {
        findDropdownData();
        floatingDropdown = _createFloatingDropdown();
        Overlay.of(context).insert(floatingDropdown);
      }
      isDropdownOpen = !isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: _toggleFloatingBox,
      child: CustomDropdownButton(selectedValue: selectedValue),
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;
  final VoidCallback onTap;

  DropDownItem({
    Key key,
    @required this.text,
    this.iconData,
    this.isSelected = false,
    this.isFirstItem = false,
    this.isLastItem = false,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Icon(iconData),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
      color: isSelected ? Colors.grey[300] : Colors.grey[100],
    );
  }
}

class DropDownFloatingBox extends StatelessWidget {
  final double itemHeight;
  final List<DropDownItem> items;

  const DropDownFloatingBox({Key key, @required this.itemHeight, this.items})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Material(
          elevation: 5,
          child: Container(
            height: items.length * itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(children: items),
          ),
        ),
      ],
    );
  }
}
