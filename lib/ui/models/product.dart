import 'dart:ui';

import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  double price;
  List<dynamic> ageRange;
  String distributor;
  String event;
  String imageUrl;
  List<dynamic> categories;
  String itemUrl;
  String gender;
  String itemId;
  double rating;

  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    this.event,
    @required this.ageRange,
    @required this.distributor,
    @required this.imageUrl,
    @required this.itemUrl,
    @required this.categories,
    @required this.gender,
    this.rating,
    this.itemId,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String name = data['name'];
    double price = data['price'] + .0;
    List<dynamic> ageRange = data['age_range'];
    String distributor = data['distributor'];
    String event = data['event'];
    List<dynamic> categories = data['categories'];
    String imageUrl = data['image_url'];
    String itemUrl = data['item_url'];
    String gender = data['gender'];
    String itemId = data['item_id'];
    double rating = data['rating'] + .0;

    return Product(
      id: documentId,
      name: name,
      price: price,
      event: event,
      imageUrl: imageUrl,
      itemUrl: itemUrl,
      ageRange: ageRange,
      distributor: distributor,
      categories: categories,
      gender: gender,
      itemId: itemId,
      rating: rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "event": event,
      "image_url": imageUrl,
      "item_url": itemUrl,
      "age_range": ageRange,
      "distributor": distributor,
      "categories": categories,
      "gender": gender,
      "item_id": itemId,
      "rating": rating,
    };
  }

  @override
  int get hashCode => hashValues(
        id,
        name,
        price,
        event,
        imageUrl,
        itemUrl,
        ageRange.join(","),
        distributor,
        categories.join(","),
        gender,
        itemId,
        rating,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Product otherProduct = other;

    return id == otherProduct.id &&
        name == otherProduct.name &&
        price == otherProduct.price &&
        event == otherProduct.event &&
        imageUrl == otherProduct.imageUrl &&
        ageRange.join(",") == otherProduct.ageRange.join(",") &&
        distributor == otherProduct.distributor &&
        categories.join(",") == otherProduct.categories.join(",") &&
        gender == otherProduct.gender &&
        itemId == otherProduct.itemId &&
        rating == otherProduct.rating;
  }

  @override
  String toString() => '''id: $id, name: $name, price: $price, event: $event, 
      imageUrl: $imageUrl, ageRange: $ageRange, distributor: $distributor, 
      categories: $categories, gender: $gender, itemId: $itemId, rating: $rating''';
}
