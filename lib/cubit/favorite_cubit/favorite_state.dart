import 'package:e_commerce_mall/features/home/data/models/product_model.dart';

/// The favourites list as every screen sees it.
///
/// [products] are full catalogue products, newest first, so a card can be built
/// from a favourite without another request.
class FavoriteState {
  final List<ProductModel> products;

  /// True only while the saved list is being read at startup.
  final bool isLoading;

  const FavoriteState({this.products = const [], this.isLoading = false});

  bool contains(int productId) =>
      products.any((product) => product.id == productId);

  int get count => products.length;

  FavoriteState copyWith({List<ProductModel>? products, bool? isLoading}) {
    return FavoriteState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
