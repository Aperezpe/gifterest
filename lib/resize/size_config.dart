import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static double appBarTitle;
  static double titleSize;
  static double subtitleSize;
  static double h1Size;
  static double h2Size;
  static double h3Size;
  static double h4Size;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    final is700Wide = screenWidth >= 700;

    titleSize = is700Wide ? safeBlockVertical * 3 : safeBlockVertical * 3.5;
    subtitleSize = is700Wide ? safeBlockVertical * 2 : safeBlockVertical * 2.5;
    h1Size = is700Wide ? safeBlockVertical * 3.7 : safeBlockVertical * 4.3;
    h2Size = is700Wide ? safeBlockVertical * 3.3 : safeBlockVertical * 3.7;
    h3Size = is700Wide ? safeBlockVertical * 2.8 : safeBlockVertical * 3.1;
    h4Size = is700Wide ? safeBlockVertical * 2.5 : safeBlockVertical * 2.8;
    appBarTitle = titleSize * 1.2;
  }
}
