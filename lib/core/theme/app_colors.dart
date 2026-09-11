import 'package:flutter/material.dart';

/// Raw palette primitives for the monochrome dark appearance.
///
/// Widgets must NOT reference these directly. Use the semantic tokens exposed
/// through `context.colors` ([AppColorTokens]) or let the component themes in
/// `AppTheme` supply the color.
///
/// The ramp is monochrome by design: one long neutral ramp (`ink`) carries every
/// surface, border and text tier, and a single warm gold is the only decorative
/// hue. On a near-black canvas that reads as restraint — depth comes from ordered
/// steps of grey and hairline borders, not from color or glow.
///
/// The four status hues (green / rose / orange / blue) exist only to keep
/// success, error, warning and info distinguishable from each other and from
/// the accent. They are deliberately desaturated so nothing ever reads as neon.
///
/// The shipped light appearance does not draw its identity from here — it is
/// defined by `auth_palette.dart`, the login and register screens' own warm
/// palette. `AppColorTokens.light` borrows only the status hues from this file.
class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // Ink — the neutral ramp. Very slightly warm-shifted (a touch of red over
  // blue) so the greys never look cold or electric next to the gold, but far
  // too subtle to read as brown. 50 is the lightest step, 950 the darkest.
  //
  // Dark mode uses the bottom of the ramp for surfaces and the top for text;
  // light mode does the reverse. Every step is a deliberate elevation level:
  //
  //   950  app background        (near-black)
  //   925  bottom nav / immersive auth screens
  //   900  cards, dialogs, sheets
  //   850  recessed areas nested inside a card
  //   800  hairline borders
  // ---------------------------------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink50 = Color(0xFFFAFAFB);
  static const Color ink100 = Color(0xFFF2F2F4); // off-white — dark-mode text
  static const Color ink200 = Color(0xFFE3E3E7);
  static const Color ink300 = Color(0xFFCBCBD1);
  static const Color ink400 = Color(0xFFA6A6AE); // muted grey — secondary text
  static const Color ink500 = Color(0xFF85858E);
  static const Color ink600 = Color(0xFF67676F);
  static const Color ink700 = Color(0xFF4A4A52);
  static const Color ink750 = Color(0xFF33333A);
  static const Color ink800 = Color(0xFF27272B); // hairline border (dark)
  static const Color ink850 = Color(0xFF1C1C20); // recessed surface (dark)
  static const Color ink900 = Color(0xFF17171A); // card surface (dark)
  static const Color ink925 = Color(0xFF101013); // immersive / nav (dark)
  static const Color ink950 = Color(0xFF08080A); // app background (near-black)

  // ---------------------------------------------------------------------------
  // Gold — the single accent. A muted honeyed gold rather than a saturated
  // yellow: on near-black it reads as brushed metal, which is the whole point.
  // gold400 is the dark-mode anchor (10.4:1 on ink950); gold700 is the
  // light-mode anchor, the deepest step that still carries white text at 5.4:1.
  // ---------------------------------------------------------------------------
  static const Color gold50 = Color(0xFFFBF4E4);
  static const Color gold100 = Color(0xFFF6E7C4);
  static const Color gold200 = Color(0xFFEFD79C);
  static const Color gold300 = Color(0xFFEBC87E);
  static const Color gold400 = Color(0xFFE3B457); // ← dark-mode anchor
  static const Color gold500 = Color(0xFFD19F3E);
  static const Color gold600 = Color(0xFFAE7F26);
  static const Color gold700 = Color(0xFF8A6212); // ← light-mode anchor
  static const Color gold800 = Color(0xFF6E4E0D);
  static const Color gold900 = Color(0xFF4A340A);
  static const Color gold950 = Color(0xFF241B0A); // tinted near-black fill

  // ---------------------------------------------------------------------------
  // Status hues. Muted on purpose: these appear in snack bars and inline
  // messages, never as decoration, so they only need to be unmistakable — not
  // loud. Each `*Subtle` step is a near-black tint for dark mode / a pale wash
  // for light mode.
  // ---------------------------------------------------------------------------

  // Green — success.
  static const Color green100 = Color(0xFFDDEFE5);
  static const Color green300 = Color(0xFF57B389);
  static const Color green700 = Color(0xFF256B49);
  static const Color green950 = Color(0xFF10211A);

  // Rose — error. Pushed well off the gold's hue so a destructive state is
  // never mistaken for an accent.
  static const Color rose100 = Color(0xFFFCE8EC);
  static const Color rose300 = Color(0xFFE06C7D);
  static const Color rose700 = Color(0xFFC1354C);
  static const Color rose950 = Color(0xFF241014);

  // Orange — warning. Shifted toward red relative to the accent so a warning
  // and the gold never collide.
  static const Color orange100 = Color(0xFFFDEEDC);
  static const Color orange300 = Color(0xFFE58B45);
  static const Color orange700 = Color(0xFF96520E);
  static const Color orange950 = Color(0xFF241605);

  // Blue — info. The only cool hue in the palette.
  static const Color blue100 = Color(0xFFE2EFF7);
  static const Color blue300 = Color(0xFF6BA6D8);
  static const Color blue700 = Color(0xFF1F5C87);
  static const Color blue950 = Color(0xFF0C1926);

  // ---------------------------------------------------------------------------
  // Translucent overlays — content laid over the immersive dark screens
  // (splash / login / sign-up / profile / bottom nav). Based on the off-white
  // text color rather than pure white so they stay in the ramp.
  // ---------------------------------------------------------------------------
  static const Color inkAlpha72 = Color(0xB8F2F2F4);
  static const Color inkAlpha56 = Color(0x8FF2F2F4);
  static const Color inkAlpha24 = Color(0x3DF2F2F4);
  static const Color inkAlpha12 = Color(0x1FF2F2F4);

  // ---------------------------------------------------------------------------
  // Elevation. Shadows stay minimal in dark mode — on a near-black canvas a
  // heavy shadow reads as smudge, so separation is carried by the surface step
  // and the hairline border instead.
  // ---------------------------------------------------------------------------
  static const Color shadowLight = Color(0x1417171A); // ink900 @ 8%
  static const Color shadowStrongLight = Color(0x1F17171A); // ink900 @ 12%
  static const Color shadowDark = Color(0x40000000); // black @ 25%
  static const Color shadowStrongDark = Color(0x66000000); // black @ 40%
  static const Color scrimLight = Color(0x8C17171A);
  static const Color scrimDark = Color(0xCC000000);

  /// Legacy alias kept so existing `AppColors.primaryColor` call sites keep
  /// compiling. Prefer `context.colors.primary`, which is theme-aware.
  static const Color primaryColor = gold400;
}
