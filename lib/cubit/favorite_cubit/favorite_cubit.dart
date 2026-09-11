import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_state.dart';
import 'package:e_commerce_mall/features/favorite/data/repositories/favorite_repo.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The one owner of the favourites list.
///
/// Provided above `MaterialApp` alongside `ThemeCubit`, because the list is not
/// one screen's state: the heart on the product page, the favourites tab and
/// anything added later all read the same instance, so a tap on the details
/// screen is already reflected in the tab behind it.
///
/// Every change updates the state first and then writes to disk, so the icon
/// never waits on storage.
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({FavoriteRepo? favoriteRepo})
    : favoriteRepo = favoriteRepo ?? FavoriteRepo(),
      super(const FavoriteState());

  final FavoriteRepo favoriteRepo;

  /// Reads the saved list once at startup. A storage failure leaves the app with
  /// an empty list rather than no app.
  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await favoriteRepo.getFavorites();
      emit(FavoriteState(products: products));
    } catch (_) {
      emit(const FavoriteState());
    }
  }

  bool isFavorite(int productId) => state.contains(productId);

  /// The heart button's action: add when absent, remove when present.
  Future<void> toggleFavorite(ProductModel product) {
    return isFavorite(product.id) ? remove(product.id) : add(product);
  }

  Future<void> add(ProductModel product) async {
    if (isFavorite(product.id)) return;
    // Newest first, matching the order the favourites screen shows.
    await _commit([product, ...state.products]);
  }

  Future<void> remove(int productId) async {
    if (!isFavorite(productId)) return;
    await _commit(
      state.products.where((product) => product.id != productId).toList(),
    );
  }

  Future<void> clear() async {
    await _commit(const []);
  }

  Future<void> _commit(List<ProductModel> products) async {
    emit(FavoriteState(products: products));
    try {
      await favoriteRepo.saveFavorites(products);
    } catch (_) {
      // The list stays correct for this run; only persistence was lost.
    }
  }
}
