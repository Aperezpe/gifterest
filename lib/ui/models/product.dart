import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  double price;
  String ageRange;
  String brand;
  String event;
  String imageUrl;
  String category;
  String gender;
  String itemId;

  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.event,
    @required this.ageRange,
    @required this.brand,
    @required this.imageUrl,
    @required this.category,
    @required this.gender,
    @required this.itemId,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String name = data['name'];
    double price = data['price'];
    String ageRange = data['age_range'];
    String brand = data['brand'];
    String event = data['event'];
    String category = data['category'];
    String imageUrl = data['image_url'];
    String gender = data['gender'];
    String itemId = data['item_id'];

    return Product(
      id: documentId,
      name: name,
      price: price,
      event: event,
      imageUrl: imageUrl,
      ageRange: ageRange,
      brand: brand,
      category: category,
      gender: gender,
      itemId: itemId,
    );
  }
}
