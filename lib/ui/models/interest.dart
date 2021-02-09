import 'dart:ui';
import 'package:meta/meta.dart';

class Interest {
  Interest({
    @required this.id,
    @required this.name,
    @required this.ageRange,
    @required this.gender,
    @required this.imageUrl,
  });

  String id;
  String name;
  List<dynamic> ageRange;
  String gender;
  String imageUrl;

  factory Interest.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    final List<dynamic> ageRange = data['age_range'];
    final String gender = data['gender'];
    final String imageUrl = data['image_url'] == ""
        ? 'https://wallpaperaccess.com/full/1137905.jpg'
        : data['image_url'];

    return Interest(
      id: documentId,
      name: name,
      ageRange: ageRange,
      gender: gender,
      imageUrl: imageUrl,
    );
  }

  @override
  int get hashCode =>
      hashValues(id, name, gender, ageRange.join(","), imageUrl);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Interest otherInterest = other;

    return id == otherInterest.id &&
        name == otherInterest.name &&
        gender == otherInterest.gender &&
        imageUrl == otherInterest.imageUrl &&
        ageRange.join(",") == otherInterest.ageRange.join(",");
  }

  @override
  String toString() => '''id: $id, name: $name, ageRange: $ageRange, 
      gender: $gender, imageUrl: $imageUrl''';
}
