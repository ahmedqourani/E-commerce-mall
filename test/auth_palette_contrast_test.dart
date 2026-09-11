import 'dart:math' as math;

import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contrast guard for the auth flow's fixed warm palette.
///
/// The orange is the delicate part: white-on-orange clears the WCAG 3:1
/// large-text bar but not the 4.5:1 normal-text bar, so this asserts the two
/// tiers separately — [AuthPalette.accent] for 18px-bold-and-up and
/// [AuthPalette.accentText] for body copy. If a future tweak brightens the
/// orange, the normal-text assertions are what will catch it.
void main() {
  double ratio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final hi = math.max(la, lb);
    final lo = math.min(la, lb);
    return (hi + 0.05) / (lo + 0.05);
  }

  void expectContrast(String label, Color fg, Color bg, double min) {
    final r = ratio(Color.alphaBlend(fg, bg), bg);
    expect(
      r,
      greaterThanOrEqualTo(min),
      reason: '$label: ${r.toStringAsFixed(2)}:1 is below the $min:1 floor',
    );
  }

  group('auth palette', () {
    test('text tiers are readable on the cream page and the card', () {
      for (final surface in <String, Color>{
        'background': AuthPalette.background,
        'card': AuthPalette.card,
      }.entries) {
        expectContrast('textPrimary on ${surface.key}', AuthPalette.textPrimary,
            surface.value, 13);
        expectContrast('textSecondary on ${surface.key}',
            AuthPalette.textSecondary, surface.value, 4.5);
      }
      // The placeholder sits on the darker field fill, not on the card.
      expectContrast(
          'textMuted on field', AuthPalette.textMuted, AuthPalette.field, 4.5);
    });

    test('the orange clears the large-text bar wherever it is large text', () {
      // The 28px bold title.
      expectContrast('accent title on background', AuthPalette.accent,
          AuthPalette.background, 3);
      // The 18px bold CTA label, in all three interaction states.
      expectContrast(
          'onAccent on accent', AuthPalette.onAccent, AuthPalette.accent, 3);
      expectContrast('onAccent on accentHover', AuthPalette.onAccent,
          AuthPalette.accentHover, 3);
      expectContrast('onAccent on accentPressed', AuthPalette.onAccent,
          AuthPalette.accentPressed, 3);
    });

    test('body-sized accent text uses the deepened step and clears 4.5', () {
      // The "Register" / "Login" links, which sit on the cream below the card.
      expectContrast('accentText on background', AuthPalette.accentText,
          AuthPalette.background, 4.5);
      expectContrast(
          'accentText on card', AuthPalette.accentText, AuthPalette.card, 4.5);
    });

    test('validation messages are readable', () {
      expectContrast('error on card', AuthPalette.error, AuthPalette.card, 4.5);
      // Error snack bars use white on the error fill.
      expectContrast(
          'onAccent on error', AuthPalette.onAccent, AuthPalette.error, 4.5);
    });

    test('borders and fills are distinguishable from what they separate', () {
      // The card is separated by hue, shadow and hairline rather than a big
      // luminance jump, so this only asserts the separation exists.
      expect(ratio(AuthPalette.card, AuthPalette.background), greaterThan(1.02),
          reason: 'the card has collapsed into the cream background');
      expect(ratio(AuthPalette.field, AuthPalette.card), greaterThan(1.05),
          reason: 'the input fill is indistinguishable from the card');
      expect(ratio(AuthPalette.fieldBorder, AuthPalette.field),
          greaterThan(1.10),
          reason: 'the input border is invisible');
      expect(ratio(AuthPalette.cardBorder, AuthPalette.background),
          greaterThan(1.10),
          reason: 'the card hairline is invisible');
      // Focus and error rings are graphical objects on the field fill.
      expect(ratio(AuthPalette.accent, AuthPalette.field), greaterThan(3),
          reason: 'the focus ring does not read against the field');
      expect(ratio(AuthPalette.error, AuthPalette.field), greaterThan(3),
          reason: 'the error ring does not read against the field');
    });

    test('interaction states are perceptible but not a colour change', () {
      final hover = ratio(AuthPalette.accent, AuthPalette.accentHover);
      final pressed = ratio(AuthPalette.accent, AuthPalette.accentPressed);
      expect(hover, greaterThan(1.05), reason: 'hover is imperceptible');
      expect(hover, lessThan(2.0), reason: 'hover reads as a different colour');
      expect(pressed, greaterThan(1.10), reason: 'pressed is imperceptible');
      expect(pressed, lessThan(2.0),
          reason: 'pressed reads as a different colour');
    });
  });
}
