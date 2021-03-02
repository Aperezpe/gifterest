import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImageBuilder extends StatelessWidget {
  ProfileImageBuilder({
    Key key,
    @required this.futureImage,
    @required this.selectedImage,
    @required this.onPressed,
  }) : super(key: key);

  final Future<dynamic> futureImage;
  final File selectedImage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<dynamic>(
        future: futureImage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.connectionState == ConnectionState.done
                ? Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.grey[300],
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 55,
                          backgroundImage: selectedImage != null
                              ? FileImage(snapshot.data)
                              : NetworkImage(snapshot.data),
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        bottom: 0.0,
                        height: 45,
                        child: FloatingActionButton(
                          child: Icon(Icons.camera_alt, color: Colors.blue),
                          backgroundColor: Colors.white,
                          onPressed: onPressed,
                        ),
                      ),
                    ],
                  )
                : Container(height: 110);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Container(height: 110);
        },
      ),
    );
  }
}
