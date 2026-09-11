import 'package:e_commerce_mall/core/theme/app_colors.dart';
import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:flutter/material.dart';

/// Semantic color tokens for the whole app.
///
/// This is the app's single source of truth for color *meaning*. Widgets read
/// tokens through `context.colors` and never hardcode a value, which is what
/// lets one widget tree render correctly in either appearance.
///
/// [light] is what the app ships: the warm cream-and-orange identity of the
/// login and register screens, extended to every screen. Its values are not
/// declared here — each anchor role points at `AuthPalette`, so the identity
/// lives in exactly one file.
///
/// Registered on [ThemeData.extensions] by `AppTheme`, so it is always
/// available anywhere below `MaterialApp`.
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.brandBackground,
    required this.onBrand,
    required this.onBrandMuted,
    required this.onBrandSubtle,
    required this.brandSurface,
    required this.onBrandSurface,
    required this.brandTileFill,
    required this.brandDivider,
    required this.primary,
    required this.primaryHover,
    required this.primaryActive,
    required this.primaryAccent,
    required this.primarySubtle,
    required this.primarySubtleBorder,
    required this.onPrimary,
    required this.onPrimarySubtle,
    required this.secondary,
    required this.secondaryHover,
    required this.secondarySubtle,
    required this.onSecondary,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.successSubtle,
    required this.onSuccess,
    required this.warning,
    required this.warningSubtle,
    required this.onWarning,
    required this.error,
    required this.errorSubtle,
    required this.onError,
    required this.info,
    required this.infoSubtle,
    required this.onInfo,
    required this.rating,
    required this.ratingSubtle,
    required this.disabled,
    required this.onDisabled,
    required this.shadow,
    required this.shadowStrong,
    required this.scrim,
  });

  // --- Immersive screens (splash, login, sign-up, profile) -------------------
  //
  // A separate family from the page roles below because the dark appearance
  // treats these screens as a distinct brand moment. Under the shipped light
  // identity there is only one identity, so each of these aliases its page
  // equivalent — kept as its own family so the dark appearance still has
  // somewhere to express the difference.

  /// Full-bleed background for the immersive screens.
  final Color brandBackground;

  /// Primary content (text, icons) placed on [brandBackground].
  final Color onBrand;

  /// Secondary content on [brandBackground].
  final Color onBrandMuted;

  /// De-emphasized content on [brandBackground].
  final Color onBrandSubtle;

  /// Cards / inputs that sit on top of [brandBackground]. Under the dark theme
  /// this is a dark-grey step up, never a light fill — a white field flares
  /// against near-black.
  final Color brandSurface;

  /// Content placed on [brandSurface].
  final Color onBrandSurface;

  /// Low-emphasis raised tile on [brandBackground].
  final Color brandTileFill;

  /// Divider drawn on [brandBackground].
  final Color brandDivider;

  // --- Primary ---------------------------------------------------------------

  /// Filled primary actions.
  final Color primary;

  /// Primary hover / focus state.
  final Color primaryHover;

  /// Primary pressed / active state.
  final Color primaryActive;

  /// Primary used as text or an icon on [surface] / [background].
  final Color primaryAccent;

  /// Tinted primary background for chips, selected rows and badges.
  final Color primarySubtle;

  /// Border that pairs with [primarySubtle].
  final Color primarySubtleBorder;

  /// Content on [primary].
  final Color onPrimary;

  /// Content on [primarySubtle].
  final Color onPrimarySubtle;

  // --- Secondary (neutral — the palette keeps exactly one accent hue) --------

  final Color secondary;
  final Color secondaryHover;
  final Color secondarySubtle;
  final Color onSecondary;

  // --- Neutral surfaces ------------------------------------------------------
  //
  // An elevation ladder, not three interchangeable greys. In dark mode the step
  // between each rung is deliberately small — separation is carried by the
  // ordered lightness plus the hairline [border], never by a heavy shadow.

  /// App / scaffold background. Near-black in dark mode.
  final Color background;

  /// Cards, sheets, dialogs, app bars. One step above [background].
  final Color surface;

  /// Recessed areas nested inside a [surface] — quantity steppers, info
  /// panels, unselected chips, image placeholders.
  final Color surfaceMuted;

  /// Hairline separator between surfaces. Subtle by design.
  final Color border;

  /// The same idea with more presence: input outlines, inactive tracks.
  final Color borderStrong;

  // --- Text ------------------------------------------------------------------

  /// Headings and body copy. The strongest tier available — >= 12:1 on every
  /// surface rung in both appearances.
  final Color textPrimary;

  /// Supporting copy, labels, descriptions. Clears 4.5:1 on every surface rung.
  final Color textSecondary;

  /// Placeholders and decorative icons. Also clears 4.5:1 — "muted" here means
  /// lower in the visual hierarchy, not below the readable floor.
  final Color textMuted;

  // --- Status ----------------------------------------------------------------

  final Color success;
  final Color successSubtle;
  final Color onSuccess;

  final Color warning;
  final Color warningSubtle;
  final Color onWarning;

  final Color error;
  final Color errorSubtle;
  final Color onError;

  final Color info;
  final Color infoSubtle;
  final Color onInfo;

  // --- Rating ----------------------------------------------------------------
  //
  // The star is the accent itself — a one-accent palette has no reason to
  // introduce a second yellow. `warning` is moved off the accent's hue instead,
  // so a rating never reads as an alert.

  final Color rating;
  final Color ratingSubtle;

  // --- States ----------------------------------------------------------------

  final Color disabled;
  final Color onDisabled;

  // --- Elevation -------------------------------------------------------------

  final Color shadow;
  final Color shadowStrong;
  final Color scrim;

  // ---------------------------------------------------------------------------
  // Dark — the monochrome appearance, kept so the `ThemeCubit` toggle stays
  // functional and so the near-black system is still one line away.
  //
  // Near-black background, cards one ordered step up, hairline borders, and a
  // single gold accent. Nothing else carries color. This is not the shipped
  // appearance: `ThemeCubit` starts on [light].
  // ---------------------------------------------------------------------------
  static const AppColorTokens dark = AppColorTokens(
    // One step above `background` rather than equal to it: the bottom nav bar
    // fills with this token and has to read as a distinct bar against the page
    // behind it, and the immersive auth screens gain a little lift for free.
    brandBackground: AppColors.ink925,
    onBrand: AppColors.ink100,
    onBrandMuted: AppColors.inkAlpha72,
    onBrandSubtle: AppColors.inkAlpha56,
    // Was pure white, which is the one thing a black theme cannot afford: a
    // full-white field or button flares against the near-black around it.
    // Fields and tiles on the immersive screens now sit one step *up* the ramp.
    brandSurface: AppColors.ink900,
    onBrandSurface: AppColors.ink100,
    brandTileFill: AppColors.ink850,
    brandDivider: AppColors.ink750,

    primary: AppColors.gold400,
    // Hover lifts, pressed settles. Both are one ramp step from `primary`, so
    // the state is unmistakable up close and invisible from across the room.
    primaryHover: AppColors.gold300,
    primaryActive: AppColors.gold500,
    primaryAccent: AppColors.gold400,
    primarySubtle: AppColors.gold950,
    primarySubtleBorder: AppColors.gold900,
    onPrimary: AppColors.ink950,
    onPrimarySubtle: AppColors.gold300,

    // Neutral, not a second hue — the palette gets exactly one accent, so a
    // secondary action is a light grey fill rather than another color.
    secondary: AppColors.ink200,
    secondaryHover: AppColors.ink100,
    secondarySubtle: AppColors.ink850,
    onSecondary: AppColors.ink950,

    background: AppColors.ink950,
    surface: AppColors.ink900,
    surfaceMuted: AppColors.ink850,
    border: AppColors.ink800,
    borderStrong: AppColors.ink750,

    textPrimary: AppColors.ink100,
    textSecondary: AppColors.ink400,
    textMuted: AppColors.ink500,

    success: AppColors.green300,
    successSubtle: AppColors.green950,
    onSuccess: AppColors.ink950,

    warning: AppColors.orange300,
    warningSubtle: AppColors.orange950,
    onWarning: AppColors.ink950,

    error: AppColors.rose300,
    errorSubtle: AppColors.rose950,
    onError: AppColors.ink950,

    info: AppColors.blue300,
    infoSubtle: AppColors.blue950,
    onInfo: AppColors.ink950,

    // The rating star simply *is* the accent here. A monochrome theme with one
    // gold has no reason to introduce a second yellow for stars.
    rating: AppColors.gold400,
    ratingSubtle: AppColors.gold950,

    disabled: AppColors.ink800,
    onDisabled: AppColors.ink600,

    shadow: AppColors.shadowDark,
    shadowStrong: AppColors.shadowStrongDark,
    scrim: AppColors.scrimDark,
  );

  // ---------------------------------------------------------------------------
  // Light — the app's appearance, defined by the login and register screens.
  //
  // Every anchor role below points at a value from `AuthPalette`, so the two
  // auth screens are literally the source of truth: warm cream page, very light
  // lavender cards, a recessed field grey, warm near-black type, and one warm
  // orange accent. Changing the identity means editing `auth_palette.dart` —
  // there is no second copy of it here.
  //
  // Two roles are computed rather than taken directly, and both are documented
  // where they are defined: `primarySubtle` / `primarySubtleBorder` are the
  // accent pre-composited over the cream, and `onPrimarySubtle` is the accent
  // text deepened one further step so it still clears 4.5:1 on that tint.
  // ---------------------------------------------------------------------------
  static const AppColorTokens light = AppColorTokens(
    // Under a single identity the immersive screens are no longer a separate
    // treatment: the splash and profile are the same cream page as everything
    // else, so these alias the page roles rather than inverting them. The bottom
    // navigation bar, which used to fill with `brandBackground` to separate
    // itself from the page, now fills with `surface` and carries a hairline.
    brandBackground: AuthPalette.background,
    onBrand: AuthPalette.textPrimary,
    onBrandMuted: AuthPalette.textSecondary,
    onBrandSubtle: AuthPalette.textMuted,
    brandSurface: AuthPalette.card,
    onBrandSurface: AuthPalette.textPrimary,
    brandTileFill: AuthPalette.field,
    brandDivider: AuthPalette.cardBorder,

    primary: AuthPalette.accent,
    primaryHover: AuthPalette.accentHover,
    primaryActive: AuthPalette.accentPressed,
    // Not `primary`: the accent is a large-text-and-graphics value, so anything
    // rendered at body size — a link, an inline icon label, a price — uses the
    // deepened step that clears 4.5:1.
    primaryAccent: AuthPalette.accentText,
    primarySubtle: AuthPalette.accentSubtle,
    primarySubtleBorder: AuthPalette.accentSubtleBorder,
    onPrimary: AuthPalette.onAccent,
    onPrimarySubtle: AuthPalette.onAccentSubtle,

    // Neutral, not a second hue. A secondary action is the same recessed grey
    // the inputs use, with the page's own type color on it.
    secondary: AuthPalette.field,
    secondaryHover: AuthPalette.fieldBorder,
    secondarySubtle: AuthPalette.card,
    onSecondary: AuthPalette.textPrimary,

    background: AuthPalette.background,
    surface: AuthPalette.card,
    surfaceMuted: AuthPalette.field,
    border: AuthPalette.cardBorder,
    borderStrong: AuthPalette.fieldBorder,

    textPrimary: AuthPalette.textPrimary,
    textSecondary: AuthPalette.textSecondary,
    textMuted: AuthPalette.textMuted,

    success: AppColors.green700,
    successSubtle: AppColors.green100,
    onSuccess: AppColors.white,

    // Amber, not `orange700`. The dark palette could afford a burnt orange for
    // warnings because its accent was a gold; against this accent an orange
    // warning is the accent, so warning takes the gold instead. Both values are
    // already in the palette — this is a reassignment, not a new color.
    warning: AppColors.gold700,
    warningSubtle: AppColors.gold50,
    onWarning: AppColors.white,

    // `rose700` is the same value as `AuthPalette.error`, named from the ramp
    // here so the four status roles stay visibly one family.
    error: AppColors.rose700,
    errorSubtle: AppColors.rose100,
    onError: AppColors.white,

    info: AppColors.blue700,
    infoSubtle: AppColors.blue100,
    onInfo: AppColors.white,

    // The star is the accent itself, at full strength — it is a graphical object
    // at 3.37:1 on a card, not text. A one-accent palette has no second yellow.
    rating: AuthPalette.accent,
    ratingSubtle: AuthPalette.accentSubtle,

    disabled: AuthPalette.field,
    onDisabled: AppColors.ink500,

    shadow: AuthPalette.cardShadow,
    shadowStrong: AuthPalette.cardShadowStrong,
    scrim: AuthPalette.scrim,
  );

  @override
  AppColorTokens copyWith({
    Color? brandBackground,
    Color? onBrand,
    Color? onBrandMuted,
    Color? onBrandSubtle,
    Color? brandSurface,
    Color? onBrandSurface,
    Color? brandTileFill,
    Color? brandDivider,
    Color? primary,
    Color? primaryHover,
    Color? primaryActive,
    Color? primaryAccent,
    Color? primarySubtle,
    Color? primarySubtleBorder,
    Color? onPrimary,
    Color? onPrimarySubtle,
    Color? secondary,
    Color? secondaryHover,
    Color? secondarySubtle,
    Color? onSecondary,
    Color? background,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? success,
    Color? successSubtle,
    Color? onSuccess,
    Color? warning,
    Color? warningSubtle,
    Color? onWarning,
    Color? error,
    Color? errorSubtle,
    Color? onError,
    Color? info,
    Color? infoSubtle,
    Color? onInfo,
    Color? rating,
    Color? ratingSubtle,
    Color? disabled,
    Color? onDisabled,
    Color? shadow,
    Color? shadowStrong,
    Color? scrim,
  }) {
    return AppColorTokens(
      brandBackground: brandBackground ?? this.brandBackground,
      onBrand: onBrand ?? this.onBrand,
      onBrandMuted: onBrandMuted ?? this.onBrandMuted,
      onBrandSubtle: onBrandSubtle ?? this.onBrandSubtle,
      brandSurface: brandSurface ?? this.brandSurface,
      onBrandSurface: onBrandSurface ?? this.onBrandSurface,
      brandTileFill: brandTileFill ?? this.brandTileFill,
      brandDivider: brandDivider ?? this.brandDivider,
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryActive: primaryActive ?? this.primaryActive,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      primarySubtleBorder: primarySubtleBorder ?? this.primarySubtleBorder,
      onPrimary: onPrimary ?? this.onPrimary,
      onPrimarySubtle: onPrimarySubtle ?? this.onPrimarySubtle,
      secondary: secondary ?? this.secondary,
      secondaryHover: secondaryHover ?? this.secondaryHover,
      secondarySubtle: secondarySubtle ?? this.secondarySubtle,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      success: success ?? this.success,
      successSubtle: successSubtle ?? this.successSubtle,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      warningSubtle: warningSubtle ?? this.warningSubtle,
      onWarning: onWarning ?? this.onWarning,
      error: error ?? this.error,
      errorSubtle: errorSubtle ?? this.errorSubtle,
      onError: onError ?? this.onError,
      info: info ?? this.info,
      infoSubtle: infoSubtle ?? this.infoSubtle,
      onInfo: onInfo ?? this.onInfo,
      rating: rating ?? this.rating,
      ratingSubtle: ratingSubtle ?? this.ratingSubtle,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      shadow: shadow ?? this.shadow,
      shadowStrong: shadowStrong ?? this.shadowStrong,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColorTokens lerp(covariant AppColorTokens? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorTokens(
      brandBackground: c(brandBackground, other.brandBackground),
      onBrand: c(onBrand, other.onBrand),
      onBrandMuted: c(onBrandMuted, other.onBrandMuted),
      onBrandSubtle: c(onBrandSubtle, other.onBrandSubtle),
      brandSurface: c(brandSurface, other.brandSurface),
      onBrandSurface: c(onBrandSurface, other.onBrandSurface),
      brandTileFill: c(brandTileFill, other.brandTileFill),
      brandDivider: c(brandDivider, other.brandDivider),
      primary: c(primary, other.primary),
      primaryHover: c(primaryHover, other.primaryHover),
      primaryActive: c(primaryActive, other.primaryActive),
      primaryAccent: c(primaryAccent, other.primaryAccent),
      primarySubtle: c(primarySubtle, other.primarySubtle),
      primarySubtleBorder: c(primarySubtleBorder, other.primarySubtleBorder),
      onPrimary: c(onPrimary, other.onPrimary),
      onPrimarySubtle: c(onPrimarySubtle, other.onPrimarySubtle),
      secondary: c(secondary, other.secondary),
      secondaryHover: c(secondaryHover, other.secondaryHover),
      secondarySubtle: c(secondarySubtle, other.secondarySubtle),
      onSecondary: c(onSecondary, other.onSecondary),
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surfaceMuted: c(surfaceMuted, other.surfaceMuted),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textMuted: c(textMuted, other.textMuted),
      success: c(success, other.success),
      successSubtle: c(successSubtle, other.successSubtle),
      onSuccess: c(onSuccess, other.onSuccess),
      warning: c(warning, other.warning),
      warningSubtle: c(warningSubtle, other.warningSubtle),
      onWarning: c(onWarning, other.onWarning),
      error: c(error, other.error),
      errorSubtle: c(errorSubtle, other.errorSubtle),
      onError: c(onError, other.onError),
      info: c(info, other.info),
      infoSubtle: c(infoSubtle, other.infoSubtle),
      onInfo: c(onInfo, other.onInfo),
      rating: c(rating, other.rating),
      ratingSubtle: c(ratingSubtle, other.ratingSubtle),
      disabled: c(disabled, other.disabled),
      onDisabled: c(onDisabled, other.onDisabled),
      shadow: c(shadow, other.shadow),
      shadowStrong: c(shadowStrong, other.shadowStrong),
      scrim: c(scrim, other.scrim),
    );
  }
}

/// Ergonomic access to the semantic tokens: `context.colors.primary`.
extension AppColorTokensX on BuildContext {
  AppColorTokens get colors =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.light;
}
