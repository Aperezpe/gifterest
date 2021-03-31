import 'package:flutter/material.dart';

class FavoritesController extends ChangeNotifier {
  Map<String, bool> _isFavorite = {};

  Map<String, bool> get isFavorite => _isFavorite;
}
