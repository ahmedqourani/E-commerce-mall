import 'dart:convert';

import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local store for the favourites list.
///
/// The API has no favourites endpoint, so this is the app's own data and lives
/// in `SharedPreferences` — the same local storage the session already uses, so
/// no new package is involved.
///
/// What is written is the product itself, encoded with [ProductModel.toJson],
/// rather than a second slimmer model or a bare list of ids. That keeps the
/// favourites screen working offline and lets it render the very same
/// `ProductGridCard` the catalogue uses, with no per-item request on open.
class FavoriteRepo {
  static const String _favoritesKey = 'favorite_products';

  /// The saved favourites, newest first — the order they were written in.
  ///
  /// An entry that cannot be decoded (a value left by an older build, or a
  /// truncated write) is skipped rather than throwing, so one bad row cannot
  /// empty the whole screen.
  Future<List<ProductModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_favoritesKey) ?? const [];

    final products = <ProductModel>[];
    for (final entry in stored) {
      try {
        final decoded = jsonDecode(entry);
        if (decoded is Map<String, dynamic>) {
          products.add(ProductModel.fromJson(decoded));
        }
      } catch (_) {
        // Unreadable row — drop it.
      }
    }
    return products;
  }

  Future<void> saveFavorites(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoritesKey,
      products.map((product) => jsonEncode(product.toJson())).toList(),
    );
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}
