import 'package:bonobo/ui/common_widgets/platform_dropdown/custom_dropdown_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../format.dart';

class IOSDatePicker extends StatelessWidget {
  const IOSDatePicker({
    Key key,
    this.initialDate,
    @required this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final DateTime initialDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  void _showDatePicker(BuildContext context) {
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  minimumYear: 1800,
                  maximumYear: 2500,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: selectDate,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: () => _showDatePicker(context),
            child: CustomDropdownButton(
              selectedValue: Format.date(selectedDate),
            ),
          ),
        ),
      ],
    );
  }
}
