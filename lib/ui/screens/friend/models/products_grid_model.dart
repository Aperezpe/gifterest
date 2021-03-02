import 'package:bonobo/services/database.dart';
import 'package:bonobo/ui/models/product.dart';
import 'package:bonobo/ui/screens/friend/event_type.dart';
import 'package:bonobo/ui/screens/my_friends/models/friend.dart';
import 'package:flutter/cupertino.dart';

class ProductsGridModel extends ChangeNotifier {
  ProductsGridModel({
    @required this.database,
    @required this.friend,
    this.eventType = EventType.any,
  });

  final FirestoreDatabase database;
  final Friend friend;
  final EventType eventType;

  Stream<List<Product>> get queryProductsStream => database.queryProductsStream(
        friend: friend,
        eventType: eventType,
      );
}
