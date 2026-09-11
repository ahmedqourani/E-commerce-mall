import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// The app's wordmark, drawn from theme tokens and type rather than a raster.
///
/// This replaces `assets/logo/logo.svg` in the UI. That asset is a single
/// merged vector path — its letterforms can't be read back or re-lettered, and
/// it was authored for the app's previous single-vertical identity. Building
/// the lockup from a glyph plus [AppStrings.brandName] keeps the mark editable,
/// recolourable by the theme, and correct at any size. The file itself is left
/// on disk, so restoring it is a one-line change.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.size = 22, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? context.colors.primaryAccent;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.storefront_outlined, size: size * 1.1, color: tint),
        SizedBox(width: size * 0.4),
        Text(
          AppStrings.brandName,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w800,
            letterSpacing: size * 0.16,
            height: 1,
            color: tint,
          ),
        ),
      ],
    );
  }
}
