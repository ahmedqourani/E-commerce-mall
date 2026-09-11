/// Backwards-compatibility shim. The color system now lives in `lib/core/theme/`:
///
/// - `AppColors`      — raw palette primitives (`core/theme/app_colors.dart`)
/// - `AppColorTokens` — semantic tokens, read via `context.colors`
/// - `AppTheme`       — light / dark `ThemeData`
///
/// Prefer importing `core/theme/app_color_tokens.dart` and using
/// `context.colors.*` in widgets so colors follow the active theme.
library;

export 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
export 'package:e_commerce_mall/core/theme/app_colors.dart';
