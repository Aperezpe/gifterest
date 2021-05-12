import 'package:auto_size_text/auto_size_text.dart';
import 'package:bonobo/resize/size_config.dart';
import 'package:bonobo/ui/models/interest.dart';
import 'package:flutter/material.dart';

class ClickableInterest extends StatelessWidget {
  ClickableInterest({
    @required this.interest,
    @required this.onTap,
    @required this.isSelected,
  });

  final Interest interest;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(
                  width: SizeConfig.safeBlockVertical - 2,
                  color: Colors.orange,
                ),
                borderRadius: BorderRadius.circular(
                  SizeConfig.safeBlockVertical * 2.5,
                ),
              )
            : BoxDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockVertical * 1.5,
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Image.network(
                  interest.imageUrl,
                  fit: BoxFit.fitHeight,
                  color: isSelected
                      ? Colors.black.withOpacity(.7)
                      : Colors.black.withOpacity(.2),
                  colorBlendMode: BlendMode.darken,
                  height: double.infinity,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: AutoSizeText(
                      "${interest.name}",
                      textAlign: TextAlign.center,
                      // minFontSize: SizeConfig.safeBlockVertical * 1.5,
                      wrapWords: false,
                      overflow: TextOverflow.clip,
                      stepGranularity: 4,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: SizeConfig.safeBlockVertical * 2.5,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
