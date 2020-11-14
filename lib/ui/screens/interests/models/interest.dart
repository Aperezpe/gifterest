import 'package:flutter/foundation.dart';

class Interest {
  Interest({
    @required this.nameId,
    @required this.ageRange,
    @required this.imageUrl,
  });

  String nameId;
  String ageRange;
  String imageUrl;

  factory Interest.fromMap(Map<String, dynamic> data, String nameId) {
    if (data == null) {
      return null;
    }

    final String ageRange = data['age_range'];
    final String imageUrl = data['image_url'];

    return Interest(
      nameId: nameId,
      ageRange: ageRange,
      imageUrl: imageUrl,
    );
  }
}
