import 'package:bonobo/ui/models/product.dart';
import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  void setFavorites(List<Product> favorites) {
    _favorites = favorites;
    notifyListeners();
  }
}
