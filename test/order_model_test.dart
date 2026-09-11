import 'package:e_commerce_mall/features/orderHistory/data/models/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Captured response shape used to verify cart-to-order parsing.
  final realCartJson = {
    'id': 1,
    'products': [
      {
        'id': 162,
        'title': 'Blue Frock',
        'price': 29.99,
        'quantity': 4,
        'total': 119.96,
        'discountPercentage': 12.75,
        'discountedTotal': 104.67,
        'thumbnail': 'https://example.com/blue.png',
      },
      {
        'id': 113,
        'title': 'Generic Motorcycle',
        'price': 3999.99,
        'quantity': 3,
        'total': 11999.97,
        'discountPercentage': 17.4,
        'discountedTotal': 9911.98,
        'thumbnail': 'https://example.com/moto.png',
      },
      {
        'id': 122,
        'title': 'iPhone 6',
        'price': 299.99,
        'quantity': 3,
        'total': 899.97,
        'discountPercentage': 10.0,
        'discountedTotal': 809.97,
        'thumbnail': 'https://example.com/iphone.png',
      },
      {
        'id': 138,
        'title': 'Baseball Ball',
        'price': 8.99,
        'quantity': 2,
        'total': 17.98,
        'discountPercentage': 8.0,
        'discountedTotal': 16.54,
        'thumbnail': 'https://example.com/ball.png',
      },
    ],
    'total': 13037.88,
    'discountedTotal': 11510.81,
    'userId': 1,
    'totalProducts': 4,
    'totalQuantity': 12,
  };

  group('OrderModel.fromJson', () {
    test('maps real dummyjson cart payload into a full order', () {
      final order = OrderModel.fromJson(realCartJson);

      expect(order.id, 1);
      expect(order.userId, 1);
      expect(order.total, 13037.88);
      expect(order.discountedTotal, 11510.81);
      expect(order.totalProducts, 4);
      expect(order.totalQuantity, 12);
    });

    test('keeps ALL products, not just the first one (the original bug)', () {
      final order = OrderModel.fromJson(realCartJson);

      expect(order.products.length, 4);
      expect(order.products.map((p) => p.title), [
        'Blue Frock',
        'Generic Motorcycle',
        'iPhone 6',
        'Baseball Ball',
      ]);
      expect(order.products.first.quantity, 4);
      expect(order.products.first.price, 29.99);
    });

    test('does not invent status/createdAt and survives missing fields', () {
      final order = OrderModel.fromJson({'id': 5});

      expect(order.id, 5);
      expect(order.userId, 0);
      expect(order.products, isEmpty);
      expect(order.total, 0.0);
      expect(order.totalProducts, 0);
      expect(order.totalQuantity, 0);
    });
  });
}
