import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/models/interest.dart';
import 'package:flutter/material.dart';

class ClickableInterest extends StatelessWidget {
  ClickableInterest({
    @required this.interest,
    @required this.onTap,
    @required this.isSelected,
    @required this.selectedInterests,
  });

  final Interest interest;
  final VoidCallback onTap;
  final bool isSelected;
  final List<String> selectedInterests;

  final Map<String, String> abbreviations = {"Skateboarding": "Sk8"};

  String _getName() => abbreviations.containsKey(interest.name)
      ? abbreviations[interest.name]
      : interest.name;

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
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: interest.imageUrl,
                    colorBlendMode: BlendMode.darken,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.safeBlockVertical * 1.5,
                        ),
                        color: isSelected
                            ? Colors.black.withOpacity(.5)
                            : Colors.black.withOpacity(.2),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitHeight,
                          colorFilter: ColorFilter.mode(
                            isSelected
                                ? Colors.black.withOpacity(.7)
                                : Colors.black.withOpacity(.2),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: AutoSizeText(
                      "${_getName()}",
                      textAlign: TextAlign.center,
                      wrapWords: false,
                      overflow: TextOverflow.clip,
                      stepGranularity: 1,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: SizeConfig.h4Size,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Visibility(
                  visible: isSelected,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    height: SizeConfig.blockSizeVertical * 3,
                    width: SizeConfig.blockSizeVertical * 3,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${selectedInterests.indexOf(interest.name) + 1}',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
