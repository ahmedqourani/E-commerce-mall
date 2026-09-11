import 'package:e_commerce_mall/core/network/api_service.dart';
import 'package:e_commerce_mall/features/cart/data/models/cart_model.dart';

class CartRepo {
  final ApiService apiService = ApiService();

  Future<CartModel> getCart() async {
    try {
      final response = await apiService.get('/carts/1');
      return CartModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await apiService.post(
        '/carts/add',
        data: {
          'userId': userId,
          'products': [
            {'id': productId, 'quantity': quantity},
          ],
        },
      );
      return CartModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}