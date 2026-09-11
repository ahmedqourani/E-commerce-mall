import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The catalogue search box.
///
/// The hint names what the catalogue actually holds — products, stores and
/// categories — rather than a single vertical, and the field itself never
/// assumes what is being searched for.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = AppStrings.searchHint,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      elevation: 4,
      color: colors.surface,
      shadowColor: colors.shadow,
      borderRadius: BorderRadius.circular(12),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            style: TextStyle(color: colors.textPrimary),
            cursorColor: colors.primary,
            decoration: InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search, color: colors.textMuted),
              // Only offered once there is something to clear.
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: Icon(Icons.close_rounded, color: colors.textMuted),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    ),
              hintText: hintText,
              hintStyle: TextStyle(color: colors.textMuted),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.border),
              ),
              // Was identical to the enabled border, so focus was invisible.
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.primary, width: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
