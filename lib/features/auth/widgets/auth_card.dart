import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:flutter/material.dart';

/// The rounded form card on the auth screens.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      // Keep the child stable so rebuilds do not restart its animation.
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        decoration: BoxDecoration(
          color: AuthPalette.card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AuthPalette.cardBorder),
          boxShadow: const [
            BoxShadow(
              color: AuthPalette.cardShadow,
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
      builder: (context, t, animatedChild) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - t)),
            child: animatedChild,
          ),
        );
      },
    );
  }
}