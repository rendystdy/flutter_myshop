import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> _setFavValue(bool newValue) {
    final oldStatus = newValue;
    isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.parse(
        'https://flutter-my-shop-2466c-default-rtdb.firebaseio.com/products/$id');
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }
}
