import 'package:bonobo/ui/style/fontStyle.dart';
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  final ValueChanged<RangeValues> onChanged;

  const CustomRangeSlider({Key key, this.onChanged}) : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  RangeValues onStartValues;
  RangeValues currentValues;
  RangeValues onEndValues;

  @override
  void initState() {
    super.initState();
    onStartValues = RangeValues(0, 100);
    currentValues = onStartValues;
    onEndValues = currentValues;
  }

  /// Prevents rangeValues to be equal
  /// TODO: Borrar de aqui cuando se vaya a ProfilePage
  void _onChangeEnd(RangeValues endValues) {
    if (onStartValues.start != endValues.start) {
      if (endValues.start == endValues.end) {
        currentValues = RangeValues(endValues.start - 10, endValues.end);
        onEndValues = currentValues;
      }
    } else if (onStartValues.end != endValues.end) {
      if (endValues.start == endValues.end) {
        currentValues = RangeValues(endValues.start, endValues.end + 10);
        onEndValues = currentValues;
      }
    } else {
      onEndValues = currentValues;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Text("Budget", style: h3),
        ),
        Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Row(
            children: [
              Container(
                  width: 25, child: Text("${currentValues.start.round()}")),
              Expanded(
                child: RangeSlider(
                  values: currentValues,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: (values) => setState(() {
                    currentValues = values;
                    widget.onChanged(values);
                  }),
                  onChangeStart: (values) => onStartValues = values,
                  onChangeEnd: _onChangeEnd,
                ),
              ),
              Container(
                width: 40,
                child: currentValues.end == 100
                    ? Text("${currentValues.end.round()}+")
                    : Text("${currentValues.end.round()}"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
