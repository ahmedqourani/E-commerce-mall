import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';

/// The category filter strip.
///
/// Replaces the old `FoodCategory`, and not just by name: the categories are
/// whatever `/products/categories` returns, so the strip describes the
/// catalogue instead of a fixed set of verticals. Selection is by the API's own
/// slug, and `null` means "All".
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedSlug,
    required this.onSelected,
    this.isLoading = false,
  });

  final List<CategoryModel> categories;

  /// `null` for the "All" chip.
  final String? selectedSlug;
  final ValueChanged<String?> onSelected;
  final bool isLoading;

  static const double _height = 42;

  @override
  Widget build(BuildContext context) {
    if (isLoading && categories.isEmpty) return const _ChipPlaceholders();
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        // The "All" chip lives at index 0, ahead of the API's own list.
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _Chip(
              label: AppStrings.categoryAll,
              isSelected: selectedSlug == null,
              onTap: () => onSelected(null),
            );
          }
          final category = categories[index - 1];
          return _Chip(
            label: category.name,
            isSelected: selectedSlug == category.slug,
            onTap: () => onSelected(category.slug),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.primary : colors.surfaceMuted,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: isSelected ? colors.primary : colors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? colors.onPrimary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps the strip's height reserved while the category list is in flight, so
/// the sections below don't jump once it lands.
class _ChipPlaceholders extends StatelessWidget {
  const _ChipPlaceholders();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: CategoryChips._height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) => Container(
          width: 76 + (index.isEven ? 22 : 0),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: colors.border),
          ),
        ),
      ),
    );
  }
}
