import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_text_styles.dart';
import 'package:flutter/material.dart';

/// Branding block for the auth screens: a small circular badge, a prominent
/// orange title and a short grey subtitle.
///
/// Shared by login and register so the two screens are consistent by
/// construction rather than by copy-paste.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The badge is a filled circle carrying its own faint orange glow —
        // an untinted grey shadow under a warm orange reads as dirt.
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AuthPalette.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AuthPalette.accentShadow,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: AuthPalette.onAccent, size: 30),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AuthTextStyles.title(context),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AuthTextStyles.subtitle(context),
        ),
      ],
    );
  }
}
