/// A product from the catalogue.
///
/// The API is a general marketplace, so the same shape has to describe a
/// mascara, a laptop, a dress and a motorcycle. Only [id], [title],
/// [description], [price], [rating] and [thumbnail] are dependable; everything
/// else is genuinely optional and is **null when the response omits it**.
///
/// That nullability is the whole point: the UI asks `product.brand != null`
/// rather than assuming a field exists, so a grocery item with no brand simply
/// renders one row fewer instead of an empty label or a placeholder.
class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;

  /// Category slug as the API spells it (`mens-shirts`, `home-decoration`).
  /// Use [categoryLabel] for display.
  final String? category;
  final String? brand;
  final double? discountPercentage;
  final int? stock;

  /// The API's own words — "In Stock", "Low Stock", "Out of Stock".
  final String? availabilityStatus;
  final String? sku;
  final double? weight;
  final ProductDimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<String> images;
  final List<String> tags;

  /// From `meta.createdAt`. Drives the "New Arrivals" rail; null means the
  /// product is simply never treated as new.
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    this.category,
    this.brand,
    this.discountPercentage,
    this.stock,
    this.availabilityStatus,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.images = const [],
    this.tags = const [],
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: _toDouble(json['price']) ?? 0,
      rating: _toDouble(json['rating']) ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      category: _toText(json['category']),
      brand: _toText(json['brand']),
      discountPercentage: _toDouble(json['discountPercentage']),
      stock: _toInt(json['stock']),
      availabilityStatus: _toText(json['availabilityStatus']),
      sku: _toText(json['sku']),
      weight: _toDouble(json['weight']),
      dimensions: json['dimensions'] is Map<String, dynamic>
          ? ProductDimensions.fromJson(json['dimensions'])
          : null,
      warrantyInformation: _toText(json['warrantyInformation']),
      shippingInformation: _toText(json['shippingInformation']),
      returnPolicy: _toText(json['returnPolicy']),
      minimumOrderQuantity: _toInt(json['minimumOrderQuantity']),
      images: _toStringList(json['images']),
      tags: _toStringList(json['tags']),
      createdAt: json['meta'] is Map<String, dynamic>
          ? DateTime.tryParse('${json['meta']['createdAt']}')
          : null,
    );
  }

  /// The inverse of [ProductModel.fromJson], so a product can be written to
  /// local storage and read back as the same object. Used by the favourites
  /// store, which keeps the product itself rather than a second, thinner copy
  /// of it — the keys are the API's own, and `createdAt` goes back under `meta`
  /// where [fromJson] looks for it.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'rating': rating,
    'thumbnail': thumbnail,
    'category': category,
    'brand': brand,
    'discountPercentage': discountPercentage,
    'stock': stock,
    'availabilityStatus': availabilityStatus,
    'sku': sku,
    'weight': weight,
    'dimensions': dimensions?.toJson(),
    'warrantyInformation': warrantyInformation,
    'shippingInformation': shippingInformation,
    'returnPolicy': returnPolicy,
    'minimumOrderQuantity': minimumOrderQuantity,
    'images': images,
    'tags': tags,
    if (createdAt != null)
      'meta': {'createdAt': createdAt!.toIso8601String()},
  };

  /// `mens-shirts` → `Mens Shirts`. Presentation only; never sent back.
  String? get categoryLabel => _humanize(category);

  /// Whether the API reported a discount worth putting a badge on.
  bool get hasDiscount => (discountPercentage ?? 0) >= 1;

  /// The store front the product belongs to. The API models this as `brand`,
  /// which many items legitimately lack.
  String? get storeName => brand;

  bool get isOutOfStock =>
      availabilityStatus?.toLowerCase() == 'out of stock' || stock == 0;

  /// Full gallery, thumbnail first, with duplicates dropped.
  List<String> get gallery {
    final all = <String>[
      if (thumbnail.isNotEmpty) thumbnail,
      ...images.where((i) => i.isNotEmpty),
    ];
    return all.toSet().toList();
  }

  /// The spec rows to render, already filtered to what the response contained.
  /// An empty result means the section is hidden entirely.
  Map<String, String> get specifications {
    final rows = <String, String>{};
    void put(String label, String? value) {
      if (value != null && value.trim().isNotEmpty) rows[label] = value.trim();
    }

    put('SKU', sku);
    put('Weight', weight == null ? null : '${_trim(weight!)} g');
    put('Dimensions', dimensions?.label);
    put('Warranty', warrantyInformation);
    put('Shipping', shippingInformation);
    put('Returns', returnPolicy);
    put(
      'Minimum order',
      minimumOrderQuantity == null || minimumOrderQuantity! <= 1
          ? null
          : '$minimumOrderQuantity units',
    );
    return rows;
  }

  static String? _humanize(String? slug) {
    if (slug == null || slug.trim().isEmpty) return null;
    return slug
        .split(RegExp(r'[-_\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static String _trim(double value) =>
      value == value.roundToDouble() ? '${value.round()}' : '$value';

  static String? _toText(Object? value) {
    if (value == null) return null;
    final text = '$value'.trim();
    return text.isEmpty ? null : text;
  }

  static double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _toInt(Object? value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<String> _toStringList(Object? value) {
    if (value is! List) return const [];
    return value.map((e) => '$e').where((e) => e.isNotEmpty).toList();
  }
}

/// Physical size, when the API reports it.
class ProductDimensions {
  final double? width;
  final double? height;
  final double? depth;

  const ProductDimensions({this.width, this.height, this.depth});

  factory ProductDimensions.fromJson(Map<String, dynamic> json) =>
      ProductDimensions(
        width: ProductModel._toDouble(json['width']),
        height: ProductModel._toDouble(json['height']),
        depth: ProductModel._toDouble(json['depth']),
      );

  Map<String, dynamic> toJson() => {
    'width': width,
    'height': height,
    'depth': depth,
  };

  /// `null` unless all three arrived, so a partial box never renders as "× ×".
  String? get label {
    if (width == null || height == null || depth == null) return null;
    return '${ProductModel._trim(width!)} × '
        '${ProductModel._trim(height!)} × '
        '${ProductModel._trim(depth!)} cm';
  }
}
