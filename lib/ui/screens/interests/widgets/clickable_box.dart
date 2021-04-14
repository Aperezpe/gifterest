import 'package:auto_size_text/auto_size_text.dart';
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
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(width: 5, color: Colors.orange),
                borderRadius: BorderRadius.circular(15.0),
              )
            : BoxDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              Center(
                child: Image.network(
                  interest.imageUrl,
                  color: isSelected
                      ? Colors.black.withOpacity(.7)
                      : Colors.black.withOpacity(.2),
                  colorBlendMode: BlendMode.darken,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: AutoSizeText(
                      "${interest.name}",
                      textAlign: TextAlign.center,
                      minFontSize: 8,
                      wrapWords: false,
                      overflow: TextOverflow.clip,
                      stepGranularity: 1,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
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
