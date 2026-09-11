import 'package:e_commerce_mall/features/auth/widgets/auth_text_styles.dart';
import 'package:flutter/material.dart';

/// The "Don't have an account? Register" line below the card.
///
/// The lead-in is grey and the action is orange and bold. The action is a real
/// [TextButton], so it has a ripple, a focus ring and a 44px-tall tap target
/// rather than being a bare tappable span.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  /// e.g. "Don't have an account?"
  final String question;

  /// e.g. "Register"
  final String action;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The action's style is passed through `styleFrom` rather than set on the
    // child `Text`: a `TextButton` is a `Material`, and `Material` animates
    // `buttonStyle.textStyle` against `textTheme.bodyMedium` as its fallback.
    // Handing it a theme-derived style keeps both ends of that animation on the
    // same `inherit` flag.
    final TextStyle actionStyle = AuthTextStyles.footerAction(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Wraps to two lines rather than overflowing when the text is long or the
      // user has scaled their font up.
      children: [
        Flexible(
          child: Text(
            question,
            textAlign: TextAlign.end,
            style: AuthTextStyles.footerQuestion(context),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            // `accentText` rather than `accent`: at 14px this is normal-size
            // text and needs the full 4.5:1.
            foregroundColor: actionStyle.color,
            textStyle: actionStyle,
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(action),
        ),
      ],
    );
  }
}
