import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/network/api_service.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';

class ProductRepo {
  final ApiService apiService = ApiService();

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiService.get('/products/$id');

      return ProductModel.fromJson(response);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
