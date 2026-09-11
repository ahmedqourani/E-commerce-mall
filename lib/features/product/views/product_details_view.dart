import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/core/utils/money.dart';
import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_state.dart';
import 'package:e_commerce_mall/features/cart/data/repositories/cart_repo.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One product, whatever kind of product it is.
///
/// Every block below the title is conditional on the API having supplied the
/// data behind it: no brand means no store row, no `warrantyInformation` means
/// no warranty row, an empty spec map means the whole Specifications section is
/// absent. Nothing is assumed about the product's nature — there are no fields
/// here that only make sense for one category, and no marketing sentence
/// asserted on the app's behalf.
class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int quantity = 1;
  bool isAddingToCart = false;
  int galleryIndex = 0;
  final CartRepo cartRepo = CartRepo();

  /// The API's `minimumOrderQuantity`, when it sets one.
  int get minQuantity {
    final min = widget.product.minimumOrderQuantity ?? 1;
    return min < 1 ? 1 : min;
  }

  @override
  void initState() {
    super.initState();
    quantity = minQuantity;
  }

  Future<void> addToCart() async {
    setState(() => isAddingToCart = true);
    try {
      await cartRepo.addToCart(
        userId: 1,
        productId: widget.product.id,
        quantity: quantity,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.success,
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppStrings.addedToCart,
            style: TextStyle(color: context.colors.onSuccess),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppStrings.addToCartFailed,
            style: TextStyle(color: context.colors.onError),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isAddingToCart = false);
    }
  }

  void increaseQuantity() => setState(() => quantity++);

  void decreaseQuantity() {
    if (quantity > minQuantity) setState(() => quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final total = product.price * quantity;
    final colors = context.colors;
    final gallery = product.gallery;
    final specs = product.specifications;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ---------------------------------------------- gallery ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Container(
                            height: 330,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: gallery.isEmpty
                                    ? Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 70,
                                        color: colors.textMuted,
                                      )
                                    : Image.network(
                                        gallery[
                                            galleryIndex.clamp(0, gallery.length - 1)],
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 70,
                                          color: colors.textMuted,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            child: _CircleButton(
                              icon: Icons.arrow_back_ios_new,
                              tooltip: 'Back',
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            // Reads the shared favourites list rather than a
                            // flag of its own, so the icon is already correct
                            // when the screen is reopened and the change is
                            // visible on the favourites tab immediately.
                            child: BlocBuilder<FavoriteCubit, FavoriteState>(
                              builder: (context, state) {
                                final isFavorite = state.contains(product.id);
                                return _CircleButton(
                                  icon: isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  tooltip: isFavorite
                                      ? AppStrings.removeFromFavorites
                                      : AppStrings.addToFavorites,
                                  iconColor: isFavorite
                                      ? colors.primaryAccent
                                      : colors.textPrimary,
                                  onTap: () => context
                                      .read<FavoriteCubit>()
                                      .toggleFavorite(product),
                                );
                              },
                            ),
                          ),
                          if (product.hasDiscount)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  Money.discountBadge(
                                      product.discountPercentage!),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: colors.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Only offered when the API returned more than one image.
                  if (gallery.length > 1)
                    SliverToBoxAdapter(
                      child: _GalleryThumbs(
                        images: gallery,
                        selectedIndex: galleryIndex,
                        onSelected: (i) => setState(() => galleryIndex = i),
                      ),
                    ),

                  // ------------------------------------------------- info ---
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.categoryLabel != null) ...[
                            Text(
                              product.categoryLabel!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                Money.format(product.price),
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Rating and availability — both straight from the
                          // API. The rating no longer carries a verdict of our
                          // own ("Excellent rating" used to show at any score).
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  color: colors.ratingSubtle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded,
                                        color: colors.rating, size: 19),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (product.availabilityStatus != null)
                                _StatusChip(
                                  // The API's own wording, verbatim.
                                  label: product.availabilityStatus!,
                                  isNegative: product.isOutOfStock,
                                ),
                              if (product.storeName != null)
                                _MetaText(
                                  icon: Icons.storefront_outlined,
                                  text: product.storeName!,
                                ),
                            ],
                          ),

                          const SizedBox(height: 25),
                          Divider(color: colors.border, height: 1),
                          const SizedBox(height: 25),

                          if (product.description.trim().isNotEmpty) ...[
                            _SectionTitle(AppStrings.description),
                            const SizedBox(height: 10),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],

                          // Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _SectionTitle(AppStrings.quantity),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: colors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    _QuantityButton(
                                      icon: Icons.remove,
                                      tooltip: 'Decrease quantity',
                                      onTap: decreaseQuantity,
                                      isEnabled: quantity > minQuantity,
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: Center(
                                        child: Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _QuantityButton(
                                      icon: Icons.add,
                                      tooltip: 'Increase quantity',
                                      onTap: increaseQuantity,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          if (minQuantity > 1) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${AppStrings.minimumOrder}: $minQuantity',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: colors.textMuted,
                              ),
                            ),
                          ],

                          // Specs — only what the response actually contained.
                          if (specs.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            _SectionTitle(AppStrings.specifications),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors.surfaceMuted,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  for (final entry in specs.entries)
                                    _SpecRow(
                                      label: entry.key,
                                      value: entry.value,
                                      isLast: entry.key == specs.keys.last,
                                    ),
                                ],
                              ),
                            ),
                          ],

                          if (product.tags.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tag in product.tags)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: colors.surfaceMuted,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: colors.border),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -------------------------------------------------- bottom bar ---
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              decoration: BoxDecoration(
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.total,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        Money.format(total),
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        // Out of stock is the API's call, so the CTA respects it.
                        onPressed: isAddingToCart || product.isOutOfStock
                            ? null
                            : addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          disabledBackgroundColor: colors.disabled,
                          disabledForegroundColor: colors.onDisabled,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: isAddingToCart
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.onDisabled,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shopping_bag_outlined,
                                      size: 21),
                                  const SizedBox(width: 9),
                                  Text(
                                    product.isOutOfStock
                                        ? (product.availabilityStatus ??
                                            'Out of Stock')
                                        : AppStrings.addToCart,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
      ),
    );
  }
}

/// One `label: value` row of the specifications table.
class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.label,
    required this.value,
    required this.isLast,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: TextStyle(fontSize: 13, color: colors.textMuted),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: colors.border, height: 1),
      ],
    );
  }
}

/// The API's availability wording, tinted by whether it is bad news.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.isNegative});

  final String label;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isNegative ? colors.errorSubtle : colors.successSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: isNegative ? colors.error : colors.success,
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// Thumbnail row for products whose response carried multiple images.
class _GalleryThumbs extends StatelessWidget {
  const _GalleryThumbs({
    required this.images,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 66,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              height: 58,
              width: 58,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Image.network(
                images[index],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  size: 18,
                  color: colors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  /// Falls back to the theme's primary text color.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = Material(
      color: colors.surface,
      shadowColor: colors.shadow,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 45,
          width: 45,
          child: Icon(icon, color: iconColor ?? colors.textPrimary, size: 20),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.isEnabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          height: 34,
          width: 34,
          child: Icon(
            icon,
            size: 18,
            color: isEnabled ? colors.textPrimary : colors.onDisabled,
          ),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
