import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:e_commerce_mall/features/home/widgets/product_card.dart';
import 'package:flutter/material.dart';

/// A favourited product in the grid.
///
/// The tile itself is the catalogue's own [ProductGridCard] — the favourites
/// screen is the same products in a different list, so it gets the same card,
/// the same badges and the same fallbacks. All this adds is the filled heart
/// that takes the product back out again.
class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.product,
    this.onTap,
    this.onRemove,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        ProductGridCard(product: product, onTap: onTap),
        Positioned(
          top: 8,
          right: 8,
          child: Tooltip(
            message: AppStrings.removeFromFavorites,
            child: Material(
              color: colors.surface,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: colors.shadow,
              child: InkWell(
                onTap: onRemove,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(
                    Icons.favorite,
                    size: 18,
                    color: colors.primaryAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
