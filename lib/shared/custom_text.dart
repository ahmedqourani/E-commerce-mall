import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  /// Defaults to the theme's primary text token, so text stays legible in both
  /// light and dark mode. Pass a token from `context.colors` to override.
  final Color? color;
  final FontWeight weight;
  final double size;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.weight = FontWeight.bold,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color ?? context.colors.textPrimary,
        fontWeight: weight,
      ),
      textAlign: TextAlign.center,
    );
  }
}
