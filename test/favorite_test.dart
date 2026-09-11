import 'dart:convert';

import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce_mall/features/favorite/data/repositories/favorite_repo.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Storage the cubit can be tested against without a platform channel, so the
/// favourites logic is checked on its own rather than through SharedPreferences.
class _InMemoryFavoriteRepo extends FavoriteRepo {
  List<String> rows = [];

  @override
  Future<List<ProductModel>> getFavorites() async => rows
      .map((row) => ProductModel.fromJson(jsonDecode(row)))
      .toList();

  @override
  Future<void> saveFavorites(List<ProductModel> products) async {
    rows = products.map((product) => jsonEncode(product.toJson())).toList();
  }
}

void main() {
  // A real /products/1 shape, trimmed to the fields the round-trip has to keep.
  final productJson = <String, dynamic>{
    'id': 1,
    'title': 'Essence Mascara Lash Princess',
    'description': 'A well-known product.',
    'price': 9.99,
    'rating': 4.94,
    'thumbnail': 'https://example.com/1.png',
    'category': 'mens-shirts',
    'brand': 'Essence',
    'discountPercentage': 7.17,
    'stock': 5,
    'availabilityStatus': 'Low Stock',
    'sku': 'RCH45Q1A',
    'weight': 2,
    'dimensions': {'width': 23.17, 'height': 14.43, 'depth': 28.01},
    'warrantyInformation': '1 month warranty',
    'shippingInformation': 'Ships in 1 month',
    'returnPolicy': '30 days return policy',
    'minimumOrderQuantity': 24,
    'images': ['https://example.com/1.png', 'https://example.com/2.png'],
    'tags': ['beauty', 'mascara'],
    'meta': {'createdAt': '2024-05-23T08:56:21.618Z'},
  };

  final product = ProductModel.fromJson(productJson);
  final otherProduct = ProductModel.fromJson({
    ...productJson,
    'id': 2,
    'title': 'Generic Motorcycle',
  });

  group('ProductModel round-trip', () {
    test('survives encode and decode, so a favourite reads back whole', () {
      final restored = ProductModel.fromJson(
        jsonDecode(jsonEncode(product.toJson())),
      );

      expect(restored.id, product.id);
      expect(restored.title, product.title);
      expect(restored.price, product.price);
      expect(restored.rating, product.rating);
      expect(restored.thumbnail, product.thumbnail);
      expect(restored.category, product.category);
      expect(restored.brand, product.brand);
      expect(restored.discountPercentage, product.discountPercentage);
      expect(restored.availabilityStatus, product.availabilityStatus);
      expect(restored.minimumOrderQuantity, product.minimumOrderQuantity);
      expect(restored.images, product.images);
      expect(restored.tags, product.tags);
      expect(restored.dimensions?.label, product.dimensions?.label);
      expect(restored.createdAt, product.createdAt);
      expect(restored.specifications, product.specifications);
    });
  });

  group('FavoriteCubit', () {
    test('toggles a product in and out of the list', () async {
      final cubit = FavoriteCubit(favoriteRepo: _InMemoryFavoriteRepo());

      expect(cubit.isFavorite(product.id), isFalse);

      await cubit.toggleFavorite(product);
      expect(cubit.isFavorite(product.id), isTrue);
      expect(cubit.state.count, 1);

      await cubit.toggleFavorite(product);
      expect(cubit.isFavorite(product.id), isFalse);
      expect(cubit.state.products, isEmpty);
    });

    test('never stores the same product twice', () async {
      final cubit = FavoriteCubit(favoriteRepo: _InMemoryFavoriteRepo());

      await cubit.add(product);
      await cubit.add(product);

      expect(cubit.state.count, 1);
    });

    test('keeps the newest favourite first', () async {
      final cubit = FavoriteCubit(favoriteRepo: _InMemoryFavoriteRepo());

      await cubit.add(product);
      await cubit.add(otherProduct);

      expect(
        cubit.state.products.map((p) => p.id).toList(),
        [otherProduct.id, product.id],
      );
    });

    test('reloads what was written, so favourites outlive the screen',
        () async {
      final repo = _InMemoryFavoriteRepo();

      final first = FavoriteCubit(favoriteRepo: repo);
      await first.add(product);
      await first.add(otherProduct);

      final second = FavoriteCubit(favoriteRepo: repo);
      await second.loadFavorites();

      expect(second.state.isLoading, isFalse);
      expect(
        second.state.products.map((p) => p.id).toList(),
        [otherProduct.id, product.id],
      );
      expect(second.isFavorite(product.id), isTrue);
    });

    test('removing a product that is not there changes nothing', () async {
      final cubit = FavoriteCubit(favoriteRepo: _InMemoryFavoriteRepo());

      await cubit.add(product);
      await cubit.remove(999);

      expect(cubit.state.count, 1);
    });
  });
}
