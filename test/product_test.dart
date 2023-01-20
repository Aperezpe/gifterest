import 'package:gifterest/ui/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test("null data", () {
      final interest = Product.fromMap(null, 'abc');
      expect(interest, null);
    });

    test("product with all properties", () {
      final product = Product.fromMap({
        'name': 'Toy',
        'price': 15.6,
        'event': 'Babyshower',
        'age_range': [0, 2],
        'distributor': "dist1",
        'image_url': "img.com",
        'item_url': 'item.com',
        'categories': ["Star Wars", "Auntie"],
        'gender': 'male',
        'item_id': "123",
      }, 'abc');

      expect(
        product,
        Product(
          id: 'abc',
          name: 'Toy',
          price: 15.6,
          ageRange: [0, 2],
          distributor: 'dist1',
          imageUrl: 'img.com',
          itemUrl: 'item.com',
          categories: ["Star Wars", "Auntie"],
          gender: 'male',
          itemId: '123',
        ),
      );
    });

    test("product without unrequired properties", () {
      final product = Product.fromMap({
        'name': 'Toy',
        'price': 15.6,
        'age_range': [0, 2],
        'distributor': "dist1",
        'image_url': "img.com",
        'item_url': 'item.com',
        'categories': ["Star Wars", "Auntie"],
        'gender': 'male'
      }, 'abc');

      expect(
        product,
        Product(
          id: 'abc',
          name: 'Toy',
          price: 15.6,
          ageRange: [0, 2],
          distributor: 'dist1',
          imageUrl: 'img.com',
          itemUrl: 'item.com',
          categories: ["Star Wars", "Auntie"],
          gender: 'male',
        ),
      );
    });
  });
}
