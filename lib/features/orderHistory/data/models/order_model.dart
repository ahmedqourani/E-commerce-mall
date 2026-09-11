import 'package:e_commerce_mall/features/cart/data/models/cart_product_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final List<CartProductModel> products;
  final double total;
  final double discountedTotal;
  final int totalProducts;
  final int totalQuantity;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      products: (json['products'] as List?)
              ?.map((p) => CartProductModel.fromJson(p))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      discountedTotal: (json['discountedTotal'] as num?)?.toDouble() ?? 0.0,
      totalProducts: json['totalProducts'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
    );
  }
}
