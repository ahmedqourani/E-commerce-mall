import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/core/theme/app_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builds the app's light and dark [ThemeData] from [AppColorTokens].
///
/// Component themes are defined here so individual widgets stay free of color
/// literals *and* of shape literals: cards, inputs, buttons, chips, dialogs,
/// sheets, snack bars and the bottom navigation bar all inherit their colors
/// from [AppColorTokens] and their radii, heights and paddings from
/// [AppMetrics] — which is to say, from the login and register screens.
///
/// A widget that needs to draw its own container should read the same two
/// classes rather than pick a number. That is the whole mechanism by which the
/// app has two radii instead of eleven.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(AppColorTokens.light, Brightness.light);

  static ThemeData get dark => _build(AppColorTokens.dark, Brightness.dark);

  static ThemeData _build(AppColorTokens t, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: t.primary,
      onPrimary: t.onPrimary,
      primaryContainer: t.primarySubtle,
      onPrimaryContainer: t.onPrimarySubtle,
      secondary: t.secondary,
      onSecondary: t.onSecondary,
      secondaryContainer: t.secondarySubtle,
      onSecondaryContainer: t.onSecondary,
      tertiary: t.info,
      onTertiary: t.onInfo,
      tertiaryContainer: t.infoSubtle,
      onTertiaryContainer: t.info,
      error: t.error,
      onError: t.onError,
      errorContainer: t.errorSubtle,
      onErrorContainer: t.error,
      surface: t.surface,
      onSurface: t.textPrimary,
      surfaceContainerHighest: t.surfaceMuted,
      onSurfaceVariant: t.textSecondary,
      outline: t.border,
      outlineVariant: t.borderStrong,
      shadow: t.shadow,
      scrim: t.scrim,
      inverseSurface: t.textPrimary,
      onInverseSurface: t.surface,
      inversePrimary: t.primaryAccent,
    );

    final base = ThemeData(brightness: brightness, colorScheme: colorScheme);

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[t],

      scaffoldBackgroundColor: t.background,
      canvasColor: t.surface,
      dividerColor: t.border,
      shadowColor: t.shadow,
      hintColor: t.textMuted,

      // Interaction states, applied to every Ink* surface in the app. Kept just
      // above the threshold of noticing: a faint neutral wash on hover, a
      // gold-tinted ripple on press, a clearly visible gold ring on focus.
      hoverColor: t.textPrimary.withValues(alpha: 0.04),
      highlightColor: t.textPrimary.withValues(alpha: 0.06),
      splashColor: t.primaryAccent.withValues(alpha: 0.10),
      focusColor: t.primaryAccent.withValues(alpha: 0.16),

      textTheme: base.textTheme.apply(
        bodyColor: t.textPrimary,
        displayColor: t.textPrimary,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.primary,
        selectionColor: t.primary.withValues(alpha: 0.24),
        selectionHandleColor: t.primary,
      ),

      iconTheme: IconThemeData(color: t.textPrimary),
      primaryIconTheme: IconThemeData(color: t.onBrand),

      appBarTheme: AppBarThemeData(
        // The page tone, not `surface`: the auth screens have no app bar at all,
        // and a header in the card color would draw a band across the top of
        // every other screen. Flat and same-as-page is what matches them.
        backgroundColor: t.background,
        foregroundColor: t.textPrimary,
        surfaceTintColor: Colors.transparent,
        shadowColor: t.shadow,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: t.textPrimary),
        actionsIconTheme: IconThemeData(color: t.textSecondary),
        titleTextStyle: TextStyle(
          color: t.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        // Without this the OS draws the wrong status-bar glyphs over the app
        // bar, or a mismatched strip above it.
        systemOverlayStyle: _overlayStyle(t, brightness),
      ),

      cardTheme: CardThemeData(
        color: t.surface,
        shadowColor: t.shadow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
          side: BorderSide(color: t.border),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
          side: BorderSide(color: t.border),
        ),
        titleTextStyle: TextStyle(
          color: t.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(
          color: t.textSecondary,
          fontSize: 14,
          height: 1.4,
        ),
      ),

      dividerTheme: DividerThemeData(color: t.border, thickness: 1, space: 1),

      listTileTheme: ListTileThemeData(
        textColor: t.textPrimary,
        iconColor: t.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusControl),
        ),
        subtitleTextStyle: TextStyle(color: t.textSecondary, fontSize: 13),
      ),

      // The auth text field, expressed once: one radius on every state, a
      // recessed fill, a hairline at rest and a 1.5dp accent ring on focus.
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: t.surfaceMuted,
        isDense: true,
        contentPadding: AppMetrics.fieldPadding,
        hintStyle: TextStyle(
          color: t.textMuted,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(color: t.textSecondary, fontSize: 15),
        floatingLabelStyle: TextStyle(color: t.primaryAccent, fontSize: 15),
        prefixIconColor: t.textMuted,
        suffixIconColor: t.textMuted,
        enabledBorder: _fieldBorder(t.border),
        focusedBorder: _fieldBorder(t.primary, width: 1.5),
        errorBorder: _fieldBorder(t.error),
        focusedErrorBorder: _fieldBorder(t.error, width: 1.5),
        disabledBorder: _fieldBorder(t.disabled),
        errorStyle: TextStyle(
          color: t.error,
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ),

      // The Login button, expressed once: full accent fill, white label, 54dp
      // tall, 28dp radius, and the accent's own tint for a shadow instead of a
      // grey one — which is what makes the orange read as lit rather than flat.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return t.primary.withValues(alpha: 0.42);
            }
            if (states.contains(WidgetState.pressed)) return t.primaryActive;
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return t.primaryHover;
            }
            return t.primary;
          }),
          foregroundColor: WidgetStateProperty.all(t.onPrimary),
          overlayColor:
              WidgetStateProperty.all(t.onPrimary.withValues(alpha: 0.12)),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          minimumSize: WidgetStateProperty.all(
            const Size(0, AppMetrics.buttonHeight),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppMetrics.radiusButton),
            ),
          ),
          textStyle: WidgetStateProperty.all(_buttonLabel),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return t.onDisabled;
            if (states.contains(WidgetState.pressed)) return t.primaryActive;
            return t.primaryAccent;
          }),
          overlayColor: WidgetStateProperty.all(
            t.primaryAccent.withValues(alpha: 0.10),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(0, AppMetrics.linkTapHeight),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: AppMetrics.gapXs),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      // The secondary shape: same silhouette as the primary, an accent hairline
      // instead of an accent fill. Nothing else changes, which is what keeps the
      // two reading as one pair.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return t.onDisabled;
            return t.primaryAccent;
          }),
          overlayColor: WidgetStateProperty.all(
            t.primaryAccent.withValues(alpha: 0.08),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: t.disabled);
            }
            return BorderSide(color: t.primarySubtleBorder);
          }),
          minimumSize: WidgetStateProperty.all(
            const Size(0, AppMetrics.buttonHeight),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppMetrics.radiusButton),
            ),
          ),
          textStyle: WidgetStateProperty.all(_buttonLabel),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return t.onDisabled;
            return t.textPrimary;
          }),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // The bar's own container paints the fill and the hairline, so the bar
        // itself stays transparent.
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        // The accent, at the step that is readable at label size: a 12dp nav
        // label needs 4.5:1, which `primary` does not reach on the bar's fill.
        selectedItemColor: t.primaryAccent,
        unselectedItemColor: t.textMuted,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        elevation: 0,
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: t.primary,
        inactiveTrackColor: t.borderStrong,
        thumbColor: t.primary,
        overlayColor: t.primary.withValues(alpha: 0.12),
        valueIndicatorColor: t.primary,
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return t.onDisabled;
          if (states.contains(WidgetState.selected)) return t.primary;
          return t.borderStrong;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return t.disabled;
          if (states.contains(WidgetState.selected)) return t.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(t.onPrimary),
        side: BorderSide(color: t.borderStrong, width: 1.5),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primary;
          return t.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primarySubtle;
          return t.surfaceMuted;
        }),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        // A spinner is a graphical object, so it takes the accent at full
        // strength rather than the deepened text step.
        color: t.primary,
        circularTrackColor: Colors.transparent,
        linearTrackColor: t.surfaceMuted,
      ),

      // A raised recessed bar rather than the inverse-surface treatment: an
      // off-white-on-dark strip would be the only high-contrast slab in an
      // otherwise soft interface. The accent action keeps it findable.
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.surfaceMuted,
        contentTextStyle: TextStyle(color: t.textPrimary, fontSize: 14),
        actionTextColor: t.primaryAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusControl),
          side: BorderSide(color: t.border),
        ),
      ),

      // Selected reads as an accent *tint*, not an accent fill. A filled orange
      // chip cannot carry a 13dp label at 4.5:1, and a row of them would make
      // the accent the loudest thing on the page.
      chipTheme: ChipThemeData(
        backgroundColor: t.surfaceMuted,
        selectedColor: t.primarySubtle,
        side: BorderSide(color: t.border),
        labelStyle: TextStyle(
          color: t.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: t.onPrimarySubtle,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusControl),
        ),
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) return t.textMuted;
          if (states.contains(WidgetState.hovered)) return t.borderStrong;
          return t.border;
        }),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppMetrics.radiusCard),
          ),
        ),
      ),
    );
  }

  /// One radius on every input state, so a field does not change shape when it
  /// gains focus or fails validation.
  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppMetrics.radiusControl),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  /// Shared button label. The auth CTA is the one button that steps up to 18 —
  /// it is the single hero action on its screen; everything else sits here.
  static const TextStyle _buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  /// Status- and navigation-bar glyph colors, both derived from the appearance
  /// so neither bar has to be kept in sync by hand.
  static SystemUiOverlayStyle _overlayStyle(
    AppColorTokens t,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      // The bottom navigation bar fills with `surface`, so the system bar below
      // it takes the same value and the two read as one surface.
      systemNavigationBarColor: t.surface,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }
}
