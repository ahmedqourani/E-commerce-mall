import 'package:e_commerce_mall/features/home/data/models/product_model.dart';

/// Derives the home screen's merchandising rails from the catalogue.
///
/// Every rail here is backed by a field the API genuinely returns. Nothing is
/// invented, sampled at random, or padded to fill a row — when the data for a
/// rail is missing the rail comes back empty and the home screen omits the
/// whole section. That is why, for example, there is no "Popular Near You":
/// the catalogue carries no popularity or location signal, so such a rail
/// could only have been faked.
class HomeSections {
  const HomeSections._();

  /// A discount below this reads as noise rather than an offer.
  static const double offerMinDiscount = 10;

  /// "Featured" means well-rated, not hand-picked — there is no editorial flag
  /// in the API, so this is the closest honest proxy.
  static const double featuredMinRating = 4.5;

  static const int railLength = 10;

  /// Biggest discounts first. Empty when nothing is meaningfully discounted.
  static List<ProductModel> specialOffers(
    List<ProductModel> products, {
    int limit = railLength,
  }) {
    final discounted = products
        .where((p) => (p.discountPercentage ?? 0) >= offerMinDiscount)
        .toList()
      ..sort((a, b) =>
          (b.discountPercentage ?? 0).compareTo(a.discountPercentage ?? 0));
    return _take(discounted, limit);
  }

  /// Highest rated first, and only those that clear [featuredMinRating] — a
  /// poorly rated product is never dressed up as featured.
  static List<ProductModel> featured(
    List<ProductModel> products, {
    int limit = railLength,
  }) {
    final rated = products.where((p) => p.rating >= featuredMinRating).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return _take(rated, limit);
  }

  /// Newest first, ordered by the API's own `meta.createdAt`. Products without
  /// that timestamp are excluded rather than assumed recent.
  static List<ProductModel> newArrivals(
    List<ProductModel> products, {
    int limit = railLength,
  }) {
    final dated = products.where((p) => p.createdAt != null).toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return _take(dated, limit);
  }

  /// The stores represented in the catalogue, busiest first.
  ///
  /// The API models a store as a product's `brand`, which plenty of items
  /// legitimately lack — those are simply not attributed to a store rather than
  /// being filed under an invented one. If nothing in the catalogue carries a
  /// brand, this returns empty and the home screen drops the section.
  static List<StoreSummary> stores(
    List<ProductModel> products, {
    int limit = 12,
  }) {
    final counts = <String, int>{};
    for (final product in products) {
      final name = product.storeName;
      if (name == null || name.isEmpty) continue;
      counts[name] = (counts[name] ?? 0) + 1;
    }

    final summaries = counts.entries
        .map((e) => StoreSummary(name: e.key, itemCount: e.value))
        .toList()
      ..sort((a, b) {
        final byCount = b.itemCount.compareTo(a.itemCount);
        return byCount != 0 ? byCount : a.name.compareTo(b.name);
      });

    return summaries.length <= limit ? summaries : summaries.sublist(0, limit);
  }

  /// Case-insensitive match over the fields a shopper would expect to search:
  /// the name, the description, the category and the brand/store.
  ///
  /// Category-agnostic by construction — it never looks for a particular kind
  /// of product, only for the words the user typed.
  static List<ProductModel> search(List<ProductModel> products, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          (p.category?.toLowerCase().contains(q) ?? false) ||
          (p.categoryLabel?.toLowerCase().contains(q) ?? false) ||
          (p.brand?.toLowerCase().contains(q) ?? false) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  static List<ProductModel> _take(List<ProductModel> list, int limit) =>
      list.length <= limit ? list : list.sublist(0, limit);
}

/// A store front in the mall, derived from the products attributed to it.
class StoreSummary {
  final String name;
  final int itemCount;

  const StoreSummary({required this.name, required this.itemCount});

  /// Up to two letters for the avatar, e.g. "Apple" → "AP", "Dior Bag" → "DB".
  String get initials {
    final words =
        name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final w = words.first;
      return (w.length == 1 ? w : w.substring(0, 2)).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
