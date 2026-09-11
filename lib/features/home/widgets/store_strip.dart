import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/features/home/data/home_sections.dart';
import 'package:flutter/material.dart';

/// Horizontal strip of the stores in the mall.
///
/// A "store" is the API's `brand`; the avatar is the store's initials rather
/// than an image, because the catalogue carries no store logo and a product
/// photo standing in for one would misrepresent it.
class StoreStrip extends StatelessWidget {
  const StoreStrip({
    super.key,
    required this.stores,
    required this.selectedStore,
    required this.onSelected,
  });

  final List<StoreSummary> stores;

  /// `null` when no store filter is applied.
  final String? selectedStore;

  /// Called with the store name, or `null` when the current one is tapped again.
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final store = stores[index];
          final isSelected = store.name == selectedStore;
          return _StoreTile(
            store: store,
            isSelected: isSelected,
            onTap: () => onSelected(isSelected ? null : store.name),
          );
        },
      ),
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile({
    required this.store,
    required this.isSelected,
    required this.onTap,
  });

  final StoreSummary store;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 82,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colors.primarySubtle : colors.surfaceMuted,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    store.initials,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? colors.onPrimarySubtle
                          : colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  store.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  AppStrings.itemCount(store.itemCount),
                  maxLines: 1,
                  style: TextStyle(fontSize: 10.5, color: colors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
