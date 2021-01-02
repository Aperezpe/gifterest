import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  double price;
  List<dynamic> ageRange;
  String distributor;
  String event;
  String imageUrl;
  String category1;
  String category2;
  String category3;
  String category4;
  String category5;
  String itemUrl;
  String gender;
  String itemId;

  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.event,
    @required this.ageRange,
    @required this.distributor,
    @required this.imageUrl,
    @required this.itemUrl,
    @required this.category1,
    @required this.category2,
    @required this.category3,
    @required this.category4,
    @required this.category5,
    @required this.gender,
    @required this.itemId,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String name = data['name'];
    double price = data['price'];
    List<dynamic> ageRange = data['age_range'];
    String distributor = data['distributor'];
    String event = data['event'];
    String category1 = data['category1'];
    String category2 = data['category2'];
    String category3 = data['category3'];
    String category4 = data['category4'];
    String category5 = data['category5'];
    String imageUrl = data['image_url'];
    String itemUrl = data['item_url'];
    String gender = data['gender'];
    String itemId = data['item_id'];

    return Product(
      id: documentId,
      name: name,
      price: price,
      event: event,
      imageUrl: imageUrl,
      itemUrl: itemUrl,
      ageRange: ageRange,
      distributor: distributor,
      category1: category1,
      category2: category2,
      category3: category3,
      category4: category4,
      category5: category5,
      gender: gender,
      itemId: itemId,
    );
  }
}
