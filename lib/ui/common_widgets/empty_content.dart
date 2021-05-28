import 'package:bonobo/resize/size_config.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  EmptyContent({
    this.title = 'Nothing here',
    this.message = 'Add a new item to get started',
    this.assetPath,
    this.bottomWidget,
    this.imageOpacity: .7,
    this.imageWidth: 200,
  });
  final String title;
  final String message;
  final String assetPath;
  final Widget bottomWidget;
  final double imageOpacity;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath != null)
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Opacity(
                  child: Image.asset(assetPath, width: imageWidth),
                  opacity: imageOpacity),
            ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.titleSize,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text(
            message,
            style: TextStyle(
              fontSize: SizeConfig.subtitleSize,
              color: Colors.black45,
            ),
          ),
          if (bottomWidget != null) SizedBox(height: 25),
          bottomWidget ?? Container(),
        ],
      ),
    );
  }
}
