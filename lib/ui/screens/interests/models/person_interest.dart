import 'package:flutter/foundation.dart';

// class PersonInterest {
//   PersonInterest({
//     @required this.id,
//     @required this.personId, // Friend or User Id
//     @required this.name,
//     @required this.age_range,
//     @required this.image_url,
//   }) : assert(personId != null);

//   String id;
//   String personId;
//   String name;
//   int age;

//   factory PersonInterest.fromMap(Map<String, dynamic> data, String documentId) {
//     if (data == null) {
//       return null;
//     }
//     final String name = data['name'];
//     final int age = data['age'];
//     final String uid = data['uid'];

//     return PersonInterest(
//       id: documentId,
//       personId: uid,
//       name: name,
//       age: age,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'age': age,
//       'personId': personId,
//     };
//   }
// }
