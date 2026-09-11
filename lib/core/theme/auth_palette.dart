import 'package:flutter/material.dart';

/// The application's palette, defined by the login and register screens.
///
/// This started as a scoped exception — a warm cream-and-orange brand moment on
/// the auth flow only — and is now the source of truth for the whole app. Every
/// anchor role in [AppColorTokens.light] points at a value from this file, so
/// there is exactly one place where the identity is decided and the rest of the
/// app inherits it through `context.colors`.
///
/// Widgets outside `features/auth` should keep reading `context.colors`, not
/// these constants. The tokens carry the same values plus the semantic meaning
/// (`surface`, `border`, `textSecondary`) that tells a widget *which* of them to
/// use; reaching past them re-hardcodes the identity that this file exists to
/// centralise.
///
/// Contrast is verified in `test/auth_palette_contrast_test.dart`, and the
/// token layer that reads from here in `test/theme_contrast_test.dart`. One rule
/// worth knowing before editing: white-on-orange clears the WCAG 3:1
/// *large-text* bar, not the 4.5:1 normal-text bar. That is why the CTA label
/// is 18px bold and up, and why body-sized accent text (the Register / Login
/// links) uses [accentText] — a deepened step — instead of [accent].
@immutable
class AuthPalette {
  const AuthPalette._();

  // --- Canvas ----------------------------------------------------------------

  /// Warm cream page background. Deliberately not pure white.
  static const Color background = Color(0xFFFDF8F1);

  /// The form card: a very light lavender. Cool enough to separate from the
  /// warm cream behind it without becoming a second accent — the separation is
  /// carried by hue, the soft shadow and the hairline, not by a big luminance
  /// jump, which is what keeps it feeling soft rather than boxed-in.
  static const Color card = Color(0xFFF5F3FB);

  /// Hairline around the card, for definition where the shadow falls off.
  static const Color cardBorder = Color(0xFFEAE7F3);

  // --- Inputs ----------------------------------------------------------------

  /// Input fill — a light grey step down from [card] so the field reads as
  /// recessed inside it.
  static const Color field = Color(0xFFEBE9F2);

  /// Subtle resting border for inputs.
  static const Color fieldBorder = Color(0xFFDDD9EA);

  // --- Accent ----------------------------------------------------------------

  /// The warm orange. Fills the CTA and the branding badge, and colors the
  /// title. Large text and graphical objects only — see the class doc.
  static const Color accent = Color(0xFFE15A10);

  /// Hover / focus: lifts.
  static const Color accentHover = Color(0xFFEC6820);

  /// Pressed: settles.
  static const Color accentPressed = Color(0xFFC64E0D);

  /// The accent deepened until it clears 4.5:1 as body text, for the
  /// "Register" / "Login" links. [accent] itself is too light for that size.
  static const Color accentText = Color(0xFFB8460D);

  /// Content on [accent].
  static const Color onAccent = Color(0xFFFFFFFF);

  /// [accent] at 12% over [background] — the tint behind a selected chip, an
  /// offer badge or a highlighted row. Pre-composited rather than translucent so
  /// it composites identically on the card and on the page.
  static const Color accentSubtle = Color(0xFFFAE5D6);

  /// [accent] at 28% over [background] — the hairline that pairs with
  /// [accentSubtle], and the outline of a secondary accent button.
  static const Color accentSubtleBorder = Color(0xFFF5CCB2);

  /// Label on [accentSubtle]. [accentText] only reaches 4.40:1 on that tint, so
  /// this is deepened one more step to clear 4.5:1 — the same move [accentText]
  /// itself makes against the cream.
  static const Color onAccentSubtle = Color(0xFFA03C09);

  // --- Text ------------------------------------------------------------------

  /// Field labels and headings. A warm near-black, never pure black.
  static const Color textPrimary = Color(0xFF292521);

  /// The subtitle under the title, and the "Don't have an account?" lead-in.
  static const Color textSecondary = Color(0xFF6E6862);

  /// Placeholders and the password-visibility icon. Deeper than
  /// [textSecondary] because it sits on the darker [field] fill, not on cream.
  static const Color textMuted = Color(0xFF656059);

  // --- Feedback --------------------------------------------------------------

  /// Validation messages and error borders.
  static const Color error = Color(0xFFC1354C);

  // --- Elevation -------------------------------------------------------------

  /// Soft warm shadow for the card. Kept low and wide so the card floats
  /// rather than sits in a box.
  static const Color cardShadow = Color(0x14312A22);

  /// The CTA and the branding badge carry a faint tint of their own color
  /// instead of a grey shadow, which is what makes the orange feel lit.
  static const Color accentShadow = Color(0x3DE15A10);

  /// [cardShadow] one step up (12% rather than 8%), for the surfaces that lift
  /// off the page rather than resting on it — dialogs, bottom sheets and the
  /// bottom navigation bar.
  static const Color cardShadowStrong = Color(0x1F312A22);

  /// Dims the page behind a dialog or sheet. [textPrimary] at 55%, so the veil
  /// is the same warm near-black as the type rather than a neutral grey.
  static const Color scrim = Color(0x8C292521);
}
