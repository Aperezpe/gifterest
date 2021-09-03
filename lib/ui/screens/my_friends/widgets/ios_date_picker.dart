import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/common_widgets/platform_dropdown/custom_dropdown_button.dart';
import 'package:gifterest/ui/screens/my_friends/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DropdownButtonBuilder<T> = Widget Function(T selectedValue);

class IOSDatePicker extends StatelessWidget {
  const IOSDatePicker({
    Key key,
    this.initialDate,
    @required this.selectedDate,
    this.selectDate,
    this.dropdownButton,
  }) : super(key: key);

  final DateTime initialDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final DropdownButtonBuilder<DateTime> dropdownButton;

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        SizeConfig().init(context);
        final is800Hight = SizeConfig.screenHeight >= 800;
        final is700Wide = SizeConfig.screenWidth >= 700;

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
            child: dropdownButton != null
                ? dropdownButton(selectedDate)
                : CustomDropdownButton(
                    selectedValue: Format.date(selectedDate),
                  ),
          ),
        ),
      ],
    );
  }
}
