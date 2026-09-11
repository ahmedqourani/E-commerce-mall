import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/network/api_service.dart';
import 'package:e_commerce_mall/features/home/data/models/category_model.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';

/// Reads the marketplace catalogue.
///
/// This deliberately does **not** pin a category. The catalogue spans every
/// vertical the API carries, and which ones exist is the server's business:
/// [getCategories] asks for the real list and [getProductsByCategory] narrows
/// to whichever one the user picked.
class HomeRepo {
  final ApiService apiService = ApiService();

  /// The whole catalogue, across every category.
  ///
  /// `limit=0` is the API's "no limit", so the home screen reflects the full
  /// catalogue rather than one vertical's slice of it.
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiService.get('/products?limit=0');
      final products = response['products'] as List;
      return products.map((product) => ProductModel.fromJson(product)).toList();
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// The categories the catalogue actually contains.
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiService.get('/products/categories');
      final List<dynamic> data = response;
      return data.map(CategoryModel.fromAny).toList();
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Products in one category, filtered by the server.
  ///
  /// [categorySlug] must be the API's own slug (`mens-shirts`, not
  /// `Mens Shirts`) — that is what the endpoint matches on.
  Future<List<ProductModel>> getProductsByCategory(String categorySlug) async {
    try {
      final response = await apiService.get('/products/category/$categorySlug');
      final products = response['products'] as List;
      return products.map((product) => ProductModel.fromJson(product)).toList();
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
