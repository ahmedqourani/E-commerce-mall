import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/network/api_service.dart';
import 'package:e_commerce_mall/core/utils/pref_helper.dart';
import '../models/order_model.dart';

class OrderRepo {
  final ApiService apiService = ApiService();

  /// Returns the current user's ID from storage or, for older sessions, /auth/me.
  Future<int> _resolveUserId() async {
    final cachedId = await PrefHelper.getUserId();
    if (cachedId != null && cachedId > 0) return cachedId;

    // Recover the ID for sessions created before it was persisted.
    final dynamic response;
    try {
      response = await apiService.get('/auth/me');
    } on ApiError {
      // Replace the default 401 message, which is misleading for this request.
      throw ApiError(message: 'Please log in again to see your orders');
    }

    final id = (response is Map) ? response['id'] : null;

    if (id is int && id > 0) {
      await PrefHelper.saveUserId(id);
      return id;
    }

    throw ApiError(message: 'Could not identify the current user');
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final userId = await _resolveUserId();

      final response = await apiService.get('/carts/user/$userId');

      final carts = (response is Map) ? response['carts'] as List? : null;
      if (carts == null) return [];

      return carts
          .whereType<Map<String, dynamic>>()
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Adds the order's products to the cart again.
  Future<void> reOrder(OrderModel order) async {
    try {
      final userId = await _resolveUserId();

      await apiService.post(
        '/carts/add',
        data: {
          'userId': userId,
          'products': order.products
              .map((p) => {'id': p.id, 'quantity': p.quantity})
              .toList(),
        },
      );
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
