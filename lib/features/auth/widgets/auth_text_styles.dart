import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:flutter/material.dart';

/// Every text style on the login and register screens, derived from the ambient
/// [TextTheme] rather than written as a free-standing literal.
///
/// **Why derive instead of writing `TextStyle(...)` inline.** A bare
/// `TextStyle(...)` carries `inherit: true`. Anything Flutter builds out of a
/// theme carries `inherit: false` — `ThemeData.localize` stamps the flag from
/// the text geometry (`typography.dart`, `inherit: false` on every 2021 entry),
/// and the Material components' own defaults are built the same way. So
/// `Theme.of(context).textTheme.bodyMedium` is `inherit: false` even though the
/// identical-looking expression *inside* a `ThemeData` builder is still
/// `inherit: true`.
///
/// `TextStyle.lerp` refuses to interpolate one of each — "Failed to interpolate
/// TextStyles with different inherit values." — and this form animates text
/// styles in two places it does not own:
///
///  * `InputDecorator` fades its label between the resting and the floating
///    style whenever the field takes focus, and folds `errorStyle.color` into
///    the floating one when validation fails
///    (`input_decorator.dart`, `AnimatedDefaultTextStyle`).
///  * every `Material` — so every button — wraps its child in an
///    `AnimatedDefaultTextStyle` whose style is
///    `buttonStyle.textStyle ?? Theme.of(context).textTheme.bodyMedium!`
///    (`material.dart:477`). Supply an `inherit: true` literal there and the two
///    branches of that `??` can no longer be interpolated with each other.
///
/// Deriving from `Theme.of(context).textTheme` puts both ends of those
/// animations on one base and one flag, which is what makes the assertion
/// unreachable rather than merely unlikely.
///
/// **Two things to keep in mind when editing.** Colors are still stamped from
/// [AuthPalette]: the auth flow keeps its cream identity under the dark theme
/// too, so it must not pick up the theme's own text colors. And never
/// hand-write `inherit: false` to "fix" a mismatch — `TextStyle.merge` returns
/// an `inherit: false` argument *verbatim* instead of merging it, so a literal
/// that omits `textBaseline` replaces the theme's and trips
/// `labelStyle.textBaseline!` inside `InputDecorator`. Deriving keeps the
/// baseline, height and font family that the null check expects.
///
/// The base slot for each style below is the one that already applied to it —
/// these screens' ambient `DefaultTextStyle` is `bodyMedium`, an input's is
/// `bodyLarge`, an error's is `bodySmall` and a button label's is `labelLarge`.
/// The refactor therefore changes the `inherit` flag and nothing that renders.
class AuthTextStyles {
  const AuthTextStyles._();

  static TextTheme _text(BuildContext context) => Theme.of(context).textTheme;

  // --- Header ----------------------------------------------------------------

  /// 28px bold clears the WCAG large-text bar, which is what lets the title use
  /// `accent` rather than the deepened `accentText`.
  static TextStyle title(BuildContext context) => _text(context).bodyMedium!.merge(
    const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AuthPalette.accent,
      letterSpacing: -0.4,
    ),
  );

  static TextStyle subtitle(BuildContext context) => _text(context).bodyMedium!.merge(
    const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AuthPalette.textSecondary,
      height: 1.4,
    ),
  );

  // --- Fields ----------------------------------------------------------------

  /// The label drawn above a field.
  static TextStyle fieldLabel(BuildContext context) => _text(context).bodyMedium!.merge(
    const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AuthPalette.textPrimary,
    ),
  );

  /// The text the user types. `bodyLarge` is the slot `TextField` itself starts
  /// from, so this is the same base it would have used.
  static TextStyle fieldValue(BuildContext context) => _text(context).bodyLarge!.merge(
    const TextStyle(fontSize: 15, color: AuthPalette.textPrimary),
  );

  static TextStyle fieldHint(BuildContext context) => _text(context).bodyLarge!.merge(
    const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AuthPalette.textMuted,
    ),
  );

  /// Validation messages. This is the one whose *color* `InputDecorator` copies
  /// into the floating label style, which is why it has to share a base with
  /// [fieldLabel] rather than stand on its own.
  static TextStyle fieldError(BuildContext context) => _text(context).bodySmall!.merge(
    const TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: AuthPalette.error,
    ),
  );

  // --- Actions ---------------------------------------------------------------

  /// The primary CTA's label. Passed to `ButtonStyle.textStyle` so the animated
  /// style inside `Material` is this one rather than the `bodyMedium` fallback —
  /// no color, because the button resolves its own `foregroundColor`.
  static TextStyle buttonLabel(BuildContext context) => _text(context).labelLarge!.merge(
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.2),
  );

  /// The "Don't have an account?" lead-in.
  static TextStyle footerQuestion(BuildContext context) => _text(context).bodyMedium!.merge(
    const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AuthPalette.textSecondary,
    ),
  );

  /// The "Register" / "Login" action. `accentText` rather than `accent`: at 14px
  /// this is normal-size text and needs the full 4.5:1.
  static TextStyle footerAction(BuildContext context) => _text(context).labelLarge!.merge(
    const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AuthPalette.accentText,
    ),
  );

  // --- Feedback --------------------------------------------------------------

  /// Content of the error snack bar, which paints on [AuthPalette.error] rather
  /// than on the page.
  static TextStyle snackBar(BuildContext context) => _text(context).bodyMedium!.merge(
    const TextStyle(color: AuthPalette.onAccent),
  );
}
