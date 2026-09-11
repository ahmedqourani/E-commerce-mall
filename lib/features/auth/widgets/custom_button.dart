import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_text_styles.dart';
import 'package:flutter/material.dart';

/// The primary CTA on the auth screens: a full-width, pill-shaped, warm orange
/// button with a white label and a faint shadow in its own color.
///
/// The public API is unchanged (`text`, `onTap`, `isLoading`), so existing call
/// sites keep working.
class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
  });

  final VoidCallback? onTap;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: isLoading
            ? null
            : const [
                BoxShadow(
                  color: AuthPalette.accentShadow,
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                // While loading the fill stays solid so the white spinner keeps
                // its contrast; a genuinely disabled button fades instead.
                return isLoading
                    ? AuthPalette.accent
                    : AuthPalette.accent.withValues(alpha: 0.42);
              }
              if (states.contains(WidgetState.pressed)) {
                return AuthPalette.accentPressed;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return AuthPalette.accentHover;
              }
              return AuthPalette.accent;
            }),
            foregroundColor: const WidgetStatePropertyAll(AuthPalette.onAccent),
            // The label style belongs here rather than on the child `Text`.
            // `Material` animates `buttonStyle.textStyle`, falling back to
            // `textTheme.bodyMedium` when it is null — so the style handed over
            // has to be theme-derived like that fallback is. A bare
            // `TextStyle(...)` (inherit: true) on one side and the theme's
            // `bodyMedium` (inherit: false) on the other is precisely the pair
            // `TextStyle.lerp` refuses to interpolate.
            textStyle: WidgetStatePropertyAll(AuthTextStyles.buttonLabel(context)),
            // The shadow is drawn by the DecoratedBox above, so Material's own
            // elevation is off — two stacked shadows read as a smudge.
            elevation: const WidgetStatePropertyAll(0),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            overlayColor: WidgetStatePropertyAll(
              AuthPalette.onAccent.withValues(alpha: 0.12),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AuthPalette.onAccent,
                  ),
                )
              // No style of its own: it takes the one the button animates, which
              // is the only way the two stay in step.
              : Text(text),
        ),
      ),
    );
  }
}
