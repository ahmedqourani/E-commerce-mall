class CartProductModel {
  final int id;
  final String title;
  final double price;
  int quantity;
  final double total;
  final double discountPercentage;
  final double discountedTotal;
  final String thumbnail;

  CartProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedTotal,
    required this.thumbnail,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      // The API uses either discountedPrice or discountedTotal by endpoint.
      discountedTotal: (json['discountedTotal'] as num?)?.toDouble() ??
          (json['discountedPrice'] as num?)?.toDouble() ??
          0.0,
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}