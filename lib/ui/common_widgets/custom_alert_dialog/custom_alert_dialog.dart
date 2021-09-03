import 'package:gifterest/resize/size_config.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String yesButtonText;
  final String noButtonText;
  final IconData icon;
  final Color iconColor;

  const CustomAlertDialog({
    Key key,
    @required this.title,
    @required this.content,
    @required this.yesButtonText,
    this.noButtonText,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final is700Wide = SizeConfig.screenWidth >= 700;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: is700Wide
          ? EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 24)
          : EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 6),
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical * 2,
          bottom: SizeConfig.safeBlockVertical * 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, SizeConfig.safeBlockVertical * 2),
              blurRadius: SizeConfig.safeBlockVertical * 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null)
              Icon(
                icon,
                color: iconColor,
                size: SizeConfig.safeBlockVertical * 7,
              ),
            SizedBox(height: SizeConfig.safeBlockVertical),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 4,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: SizeConfig.h3Size,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 4,
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: SizeConfig.subtitleSize,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            _buildActions(context),
          ],
        ),
      ),
    );
    // );
  }

  Widget _buildActions(BuildContext context) {
    final double buttonFontSize = SizeConfig.subtitleSize;

    if (noButtonText != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text(
                noButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: SizeConfig.safeBlockVertical * 2,
            color: Colors.black38,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: Text(
                yesButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    else
      return Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text(
            yesButtonText,
            style: TextStyle(
              fontSize: buttonFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.pink,
            ),
          ),
        ),
      );
  }
}
