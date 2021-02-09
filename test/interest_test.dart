import 'package:bonobo/ui/models/interest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test("null data", () {
      final interest = Interest.fromMap(null, 'abc');
      expect(interest, null);
    });

    test("interest with all properties", () {
      final interest = Interest.fromMap({
        'name': 'Blogging',
        'gender': "male",
        'age_range': [12, 100],
        'image_url': "url.com",
      }, 'abc');

      expect(
        interest,
        Interest(
          id: 'abc',
          name: 'Blogging',
          ageRange: [12, 100],
          gender: 'male',
          imageUrl: 'url.com',
        ),
      );
    });
  });
}
