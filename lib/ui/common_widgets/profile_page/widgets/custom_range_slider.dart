import 'package:auto_size_text/auto_size_text.dart';
import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/ui/style/fontStyle.dart';
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  final ValueChanged<RangeValues> onChanged;

  const CustomRangeSlider({Key key, @required this.onChanged})
      : super(key: key);

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
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1.5),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 2,
      ),
      child: Card(
        color: Colors.grey[200],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockVertical * 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: is700Wide ? 0 : SizeConfig.safeBlockHorizontal,
                ),
                child: Text(
                  "Budget",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                    fontSize: is700Wide
                        ? SizeConfig.safeBlockVertical * 3
                        : SizeConfig.safeBlockVertical * 3.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: is700Wide ? 0 : SizeConfig.safeBlockHorizontal * 2,
                ),
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 6,
                      child: AutoSizeText(
                        "${currentValues.start.round()}",
                        wrapWords: false,
                        stepGranularity: .1,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: is700Wide
                              ? SizeConfig.safeBlockVertical * .65
                              : SizeConfig.safeBlockVertical * .8,
                          rangeThumbShape: RoundRangeSliderThumbShape(
                            enabledThumbRadius: is700Wide
                                ? SizeConfig.safeBlockVertical * 1.1
                                : SizeConfig.safeBlockVertical * 1.3,
                          ),
                        ),
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
                    ),
                    Container(
                      width: is700Wide
                          ? SizeConfig.safeBlockHorizontal * 6
                          : SizeConfig.safeBlockHorizontal * 12,
                      child: AutoSizeText(
                        currentValues.end == 100
                            ? "${currentValues.end.round()}+"
                            : "${currentValues.end.round()}",
                        wrapWords: false,
                        stepGranularity: .1,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
