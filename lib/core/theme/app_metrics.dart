import 'package:flutter/material.dart';

/// Shape and spacing constants, taken from the login and register screens.
///
/// The colors of that identity live in `auth_palette.dart`; its *geometry* lives
/// here. Every value below is a measurement of something the auth flow already
/// renders, so a component that reads from this class inherits the same
/// silhouette instead of inventing a radius or a gap of its own.
///
/// Only two radii exist on purpose. A palette with one accent and a UI with two
/// radii is what makes the app feel like one product; the failure mode this
/// guards against is a screen where the card, the button, the chip and the image
/// each round differently.
@immutable
class AppMetrics {
  const AppMetrics._();

  // --- Radii -----------------------------------------------------------------

  /// Cards, dialogs, sheets, and images that fill one of them. The auth form
  /// card's radius.
  static const double radiusCard = 28;

  /// Inputs, chips, badges, small tiles and wells nested inside a card. The
  /// auth text field's radius.
  static const double radiusControl = 14;

  /// Buttons. The same 28 as [radiusCard] against a 54dp height, which is what
  /// makes the primary CTA read as a pill rather than a rounded box.
  static const double radiusButton = 28;

  // --- Spacing ---------------------------------------------------------------
  //
  // The auth screens use 8 / 18 / 26 / 32 vertically and 24 horizontally. Those
  // are the whole scale; [gapSm] is the one addition, for grid and rail gutters
  // where 18 would leave a two-column layout too little room for the cards.

  /// Page horizontal padding. Matches `AuthScaffold`.
  static const double gutter = 24;

  /// Page vertical padding. Matches `AuthScaffold`.
  static const double gutterVertical = 28;

  /// Label to field, icon to label — the tightest meaningful gap.
  static const double gapXs = 8;

  /// Grid and rail spacing, and the gap between stacked lines inside a card.
  static const double gapSm = 12;

  /// Between sibling controls, e.g. one form field and the next.
  static const double gapMd = 18;

  /// Between a group of controls and the action that commits them.
  static const double gapLg = 26;

  /// Between one page section and the next.
  static const double gapSection = 32;

  // --- Containers ------------------------------------------------------------

  /// Card padding. Matches `AuthCard`.
  static const EdgeInsets cardPadding =
      EdgeInsets.symmetric(horizontal: 22, vertical: 26);

  /// Input content padding. Matches the auth text field.
  static const EdgeInsets fieldPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  /// Caps the content on a tablet or a desktop window so a form or a list does
  /// not stretch to an unreadable line length. Matches `AuthScaffold`.
  static const double contentMaxWidth = 440;

  // --- Controls --------------------------------------------------------------

  /// Primary and secondary button height. Matches the auth CTA.
  static const double buttonHeight = 54;

  /// Minimum tap target for an inline text action, per Material's 44dp floor.
  static const double linkTapHeight = 44;

  // --- Elevation -------------------------------------------------------------

  /// The auth card's shadow: low, wide and soft, so a full-width container
  /// floats rather than sits in a box. Pass `context.colors.shadow`.
  static List<BoxShadow> cardShadow(Color color) => [
        BoxShadow(color: color, blurRadius: 28, offset: const Offset(0, 10)),
      ];

  /// The same shadow scaled down for a small card — a product tile in a
  /// two-column grid, a rail item. A 28dp blur under a 150dp card reads as haze
  /// rather than lift.
  static List<BoxShadow> softShadow(Color color) => [
        BoxShadow(color: color, blurRadius: 18, offset: const Offset(0, 6)),
      ];

  /// The accent's own tint under a filled primary action, which is what makes
  /// the orange look lit instead of pasted on. Pass the accent itself — the 24%
  /// is the alpha the login button ships, so applying it here means a caller
  /// cannot reproduce the glow at the wrong strength.
  static List<BoxShadow> accentShadow(Color accent) => [
        BoxShadow(
          color: accent.withValues(alpha: 0.24),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}
