import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_state.dart';
import 'package:e_commerce_mall/features/favorite/widegets/favorite_card.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:e_commerce_mall/features/product/views/product_details_view.dart';
import 'package:e_commerce_mall/shared/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// The favourites tab.
///
/// Purely a view of `FavoriteCubit`: it holds no list of its own, so a heart
/// tapped on the product page is already reflected here when the tab comes
/// forward, and the list survives leaving and reopening the screen.
class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  void openProduct(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailsView(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favorites)),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.products.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: AppStrings.noFavoritesTitle,
              message: AppStrings.noFavoritesBody,
            );
          }

          // Same masonry grid as the catalogue, so the two lists read as one
          // shop rather than two different screens.
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: const EdgeInsets.fromLTRB(15, 16, 15, 24),
            physics: const BouncingScrollPhysics(),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return FavoriteCard(
                product: product,
                onTap: () => openProduct(context, product),
                onRemove: () =>
                    context.read<FavoriteCubit>().remove(product.id),
              );
            },
          );
        },
      ),
    );
  }
}
