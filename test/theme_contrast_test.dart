import 'dart:math' as math;

import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contrast guard for the color system.
///
/// Every pairing the UI actually renders is checked against the WCAG 2.1
/// minimum for its role, in both appearances. This exists so a future palette
/// tweak that looks fine in isolation can't quietly push a text tier below the
/// readable floor.
///
/// Thresholds: 4.5:1 normal text, 3:1 large text and graphical objects (icons,
/// borders that carry meaning, control fills). Disabled content is exempt from
/// WCAG by design and is not asserted here.
///
/// Some floors are per-appearance, held in [_Floors], because the two palettes
/// are not the same kind of palette. The dark ramp is off-white type on
/// near-black, which clears the AAA tiers with room to spare, so its floors are
/// set well above WCAG to catch drift early. The light identity is the auth
/// screens' warm palette, whose values are fixed by
/// `test/auth_palette_contrast_test.dart`; its floors here are that file's
/// floors, so the two guards agree instead of one forbidding what the other
/// requires. Lowering a light floor below WCAG is never the fix.
void main() {
  /// WCAG relative-luminance contrast ratio. `Color.computeLuminance` is the
  /// WCAG formula, but it ignores alpha — translucent foregrounds must be
  /// composited over their real backdrop first, which [flatten] does.
  double ratio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final hi = math.max(la, lb);
    final lo = math.min(la, lb);
    return (hi + 0.05) / (lo + 0.05);
  }

  /// Flattens a possibly-translucent foreground onto its backdrop.
  Color flatten(Color fg, Color bg) => Color.alphaBlend(fg, bg);

  void expectContrast(
    String label,
    Color fg,
    Color bg,
    double min,
  ) {
    final r = ratio(flatten(fg, bg), bg);
    expect(
      r,
      greaterThanOrEqualTo(min),
      reason:
          '$label: ${r.toStringAsFixed(2)}:1 is below the $min:1 floor '
          '(fg ${_hex(fg)} on bg ${_hex(bg)})',
    );
  }

  for (final entry in <String, ({AppColorTokens tokens, _Floors floors})>{
    'dark': (tokens: AppColorTokens.dark, floors: _Floors.dark),
    'light': (tokens: AppColorTokens.light, floors: _Floors.light),
  }.entries) {
    final mode = entry.key;
    final t = entry.value.tokens;
    final f = entry.value.floors;

    group('$mode theme', () {
      test('text tiers clear their floors on all three surface rungs', () {
        for (final surface in <String, Color>{
          'background': t.background,
          'surface': t.surface,
          'surfaceMuted': t.surfaceMuted,
        }.entries) {
          expectContrast(
            'textPrimary on ${surface.key}',
            t.textPrimary,
            surface.value,
            f.textPrimary,
          );
          expectContrast(
            'textSecondary on ${surface.key}',
            t.textSecondary,
            surface.value,
            f.textSecondary,
          );
          expectContrast(
            'textMuted on ${surface.key}',
            t.textMuted,
            surface.value,
            4.5,
          );
        }
      });

      test('accent reads as text and as a fill', () {
        // Used as icon + link color directly on the page and on cards. This tier
        // is always 4.5:1 — it is the point of having a separate `primaryAccent`
        // step, and it is what a filled accent is *not* asked to do.
        expectContrast('primaryAccent on background', t.primaryAccent,
            t.background, 4.5);
        expectContrast(
            'primaryAccent on surface', t.primaryAccent, t.surface, 4.5);
        // Label on a filled primary button, plus its two interaction states —
        // a hover that breaks contrast is still a bug.
        expectContrast(
            'onPrimary on primary', t.onPrimary, t.primary, f.onPrimary);
        expectContrast('onPrimary on primaryHover', t.onPrimary, t.primaryHover,
            f.onPrimary);
        expectContrast('onPrimary on primaryActive', t.onPrimary,
            t.primaryActive, f.onPrimary);
        expectContrast('onPrimarySubtle on primarySubtle', t.onPrimarySubtle,
            t.primarySubtle, 4.5);
      });

      test('secondary fill carries its label', () {
        expectContrast(
            'onSecondary on secondary', t.onSecondary, t.secondary, 4.5);
        expectContrast('onSecondary on secondaryHover', t.onSecondary,
            t.secondaryHover, 4.5);
      });

      test('status colors carry their labels and read as inline text', () {
        for (final s in <String, List<Color>>{
          'success': [t.success, t.successSubtle, t.onSuccess],
          'warning': [t.warning, t.warningSubtle, t.onWarning],
          'error': [t.error, t.errorSubtle, t.onError],
          'info': [t.info, t.infoSubtle, t.onInfo],
        }.entries) {
          final base = s.value[0];
          final subtle = s.value[1];
          final on = s.value[2];
          expectContrast('on${s.key} on ${s.key}', on, base, 4.5);
          // Status text is rendered directly on a card (e.g. a failed order).
          expectContrast('${s.key} on surface', base, t.surface, 4.5);
          // And as text inside its own tinted container.
          expectContrast('${s.key} on ${s.key}Subtle', base, subtle, 4.5);
        }
      });

      test('rating star is visible as a graphical object', () {
        expectContrast('rating on surface', t.rating, t.surface, 3);
        expectContrast(
            'rating on ratingSubtle', t.rating, t.ratingSubtle, 3);
      });

      test('immersive screens keep their content readable', () {
        expectContrast('onBrand on brandBackground', t.onBrand,
            t.brandBackground, f.textPrimary);
        expectContrast('onBrandMuted on brandBackground', t.onBrandMuted,
            t.brandBackground, 4.5);
        // Unselected bottom-nav items — icon + small label.
        expectContrast('onBrandSubtle on brandBackground', t.onBrandSubtle,
            t.brandBackground, 4.5);
        expectContrast('onBrandSurface on brandSurface', t.onBrandSurface,
            t.brandSurface, f.textPrimary);
        // Field hint and focus ring on the auth screens.
        expectContrast(
            'textMuted on brandSurface', t.textMuted, t.brandSurface, 4.5);
        expectContrast(
            'primary on brandSurface', t.primary, t.brandSurface, 3);
        // The profile field's label sits on the screen itself, its floating
        // label turns accent, and validation text lands on both. These are the
        // pairings that break the moment brand* stops following the mode.
        expectContrast('textSecondary on brandBackground', t.textSecondary,
            t.brandBackground, 4.5);
        expectContrast('primaryAccent on brandBackground', t.primaryAccent,
            t.brandBackground, 4.5);
        expectContrast(
            'error on brandBackground', t.error, t.brandBackground, 4.5);
        expectContrast('error on brandSurface', t.error, t.brandSurface, 4.5);
        // The auth CTA is a filled accent button on the immersive screen.
        expectContrast('onPrimary on primary (auth CTA)', t.onPrimary,
            t.primary, f.onPrimary);
        expectContrast(
            'primary fill on brandBackground', t.primary, t.brandBackground, 3);
        expectContrast('onBrand on brandTileFill', t.onBrand,
            t.brandTileFill, f.textPrimary);
        expectContrast('onBrandMuted on brandTileFill', t.onBrandMuted,
            t.brandTileFill, 4.5);
      });

      test('surface rungs form a strictly ordered elevation ladder', () {
        final bg = t.background.computeLuminance();
        final surface = t.surface.computeLuminance();
        final muted = t.surfaceMuted.computeLuminance();
        // Dark mode climbs away from black; light mode steps down from white.
        // Either way the three rungs must never collapse into each other.
        expect(surface, isNot(closeTo(bg, 0.0005)),
            reason: '$mode: surface is indistinguishable from background');
        expect(muted, isNot(closeTo(surface, 0.0005)),
            reason: '$mode: surfaceMuted is indistinguishable from surface');
        // The bottom navigation bar fills with `surface` and separates from the
        // page with a `border` hairline along its top. In the light appearance
        // the bar and the page are two adjacent near-white tones, so that
        // hairline is carrying the separation and has to be visible on the page
        // and not only on the bar.
        expect(ratio(t.border, t.background), greaterThan(1.10),
            reason: '$mode: the bottom nav has no visible top edge');
      });

      test('borders are visible against the surfaces they separate', () {
        // Hairlines are meant to be subtle, so this is a floor on *existence*,
        // not the 3:1 graphical-object threshold: a border that fails here is
        // not subtle, it is absent.
        expect(ratio(t.border, t.surface), greaterThan(1.10),
            reason: '$mode: border is invisible on surface');
        expect(ratio(t.borderStrong, t.surface), greaterThan(1.25),
            reason: '$mode: borderStrong has no presence on surface');
        // Input outlines sit on the page, not on a card.
        expect(ratio(t.borderStrong, t.background), greaterThan(1.25),
            reason: '$mode: input outline is invisible on the page');
        // Immersive screens: the profile divider, and the Log Out ghost button
        // whose outline is the only thing distinguishing it from the screen.
        expect(ratio(t.brandDivider, t.brandBackground), greaterThan(1.10),
            reason: '$mode: profile divider is invisible');
        expect(ratio(t.borderStrong, t.brandBackground), greaterThan(1.25),
            reason: '$mode: ghost button has no edge');
      });

      test('interaction states are perceptible but not loud', () {
        // Clear-but-subtle, quantified: a visible shift that stops well short
        // of reading as a different color.
        final hover = ratio(t.primary, t.primaryHover);
        final active = ratio(t.primary, t.primaryActive);
        expect(hover, greaterThan(1.10),
            reason: '$mode: hover is imperceptible (${hover.toStringAsFixed(2)}:1)');
        expect(hover, lessThan(2.2),
            reason: '$mode: hover is a color change, not a state');
        expect(active, greaterThan(1.10),
            reason: '$mode: pressed is imperceptible (${active.toStringAsFixed(2)}:1)');
        expect(active, lessThan(2.2),
            reason: '$mode: pressed is a color change, not a state');
      });
    });
  }

  test('the palette commits to a single accent hue', () {
    // Guards the "avoid using too many colors" requirement structurally:
    // secondary must stay neutral, or the app has two accents.
    //
    // Measured in HSV, not HSL. HSL saturation is computed against the distance
    // from mid-grey, so it inflates without bound as a color approaches white:
    // the light appearance's `secondary` (#EBE9F2) is a near-white tint that
    // reads as 0.26 in HSL and 0.04 in HSV. HSV is the metric that matches what
    // this test is asking — "is there pigment here" — and it still catches a
    // real second accent (the orange is 0.93).
    for (final t in [AppColorTokens.dark, AppColorTokens.light]) {
      final c = HSVColor.fromColor(t.secondary);
      expect(c.saturation, lessThan(0.10),
          reason: 'secondary ${_hex(t.secondary)} is a second accent hue');
    }
  });

  group('the light appearance is the auth screens', () {
    // The brief was explicit that the login and register screens are the source
    // of truth, not a style that happens to match one. These assertions are what
    // make that structural: every identity-bearing role in the light tokens is
    // the same value as the auth constant it comes from, so the palette cannot
    // drift from the two screens that define it without failing here.
    const t = AppColorTokens.light;

    test('surfaces, borders and text come from the auth palette', () {
      expect(t.background, AuthPalette.background);
      expect(t.surface, AuthPalette.card);
      expect(t.surfaceMuted, AuthPalette.field);
      expect(t.border, AuthPalette.cardBorder);
      expect(t.borderStrong, AuthPalette.fieldBorder);
      expect(t.textPrimary, AuthPalette.textPrimary);
      expect(t.textSecondary, AuthPalette.textSecondary);
      expect(t.textMuted, AuthPalette.textMuted);
    });

    test('the accent and its states come from the auth palette', () {
      expect(t.primary, AuthPalette.accent);
      expect(t.primaryHover, AuthPalette.accentHover);
      expect(t.primaryActive, AuthPalette.accentPressed);
      expect(t.primaryAccent, AuthPalette.accentText);
      expect(t.onPrimary, AuthPalette.onAccent);
    });

    test('the immersive roles resolve to the page, not a second background', () {
      // Before the identity was unified these were a separate near-black
      // treatment for the auth screens. They now alias the page roles, which is
      // what stops the auth screens from being a visual island.
      expect(t.brandBackground, t.background);
      expect(t.brandSurface, t.surface);
      expect(t.brandTileFill, t.surfaceMuted);
      expect(t.onBrand, t.textPrimary);
      expect(t.onBrandMuted, t.textSecondary);
      expect(t.onBrandSubtle, t.textMuted);
      expect(t.brandDivider, t.border);
    });
  });
}

/// Per-appearance contrast floors.
///
/// Only the roles where the two palettes legitimately differ live here.
/// Everything else is asserted at a single shared threshold.
class _Floors {
  const _Floors({
    required this.textPrimary,
    required this.textSecondary,
    required this.onPrimary,
  });

  /// The dark ramp: off-white on near-black, so the tiers land far above WCAG
  /// and the floors are set high to catch drift long before it becomes a
  /// readability problem.
  static const _Floors dark = _Floors(
    textPrimary: 13,
    textSecondary: 7,
    onPrimary: 4.5,
  );

  /// The auth identity. Three floors sit lower than the dark ramp's, each
  /// because of a documented property of this palette rather than a concession.
  /// All three are still at or above the WCAG requirement for the text size that
  /// actually renders in them:
  ///
  /// `textPrimary` (#292521) measures 14.39:1 on the cream page and 13.83:1 on
  /// the card, but 12.65:1 on the recessed field fill — the lightest tone the
  /// dark text ever sits on is what costs it the last ratio point. Still nearly
  /// double the AAA requirement.
  ///
  /// `textSecondary` (#6E6862) measures 5.20:1 on the cream page and 4.57:1 on
  /// the field fill — past the 4.5:1 requirement for the 14dp body text it
  /// renders, short of AAA. `test/auth_palette_contrast_test.dart` has always
  /// held this color to 4.5, so this is the two guards agreeing on one number.
  ///
  /// `onPrimary` is white on the accent orange at 3.70:1. That is the WCAG
  /// large-text / graphical-object tier, and it is the ratio the login button
  /// already ships; `AuthPalette` documents the choice where the accent is
  /// defined. Body-size accent text does not use this pairing — it uses
  /// `primaryAccent`, which is asserted at 4.5 above and is the reason the two
  /// steps exist separately.
  static const _Floors light = _Floors(
    textPrimary: 12,
    textSecondary: 4.5,
    onPrimary: 3,
  );

  final double textPrimary;
  final double textSecondary;
  final double onPrimary;
}

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
