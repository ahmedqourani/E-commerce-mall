import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CheckoutWidget extends StatelessWidget {
  const CheckoutWidget({
    required this.text,
    required this.price,
    this.color,
    this.weight,
    this.size,
  });
  final String text;
  final String price;
  final Color? color;
  final FontWeight? weight;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final labelColor = color ?? context.colors.textSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: text,
          size: size ?? 15,
          weight: weight ?? FontWeight.w400,
          color: labelColor,
        ),
        CustomText(
          text: price,
          size: size ?? 15,
          weight: weight ?? FontWeight.w400,
          color: labelColor,
        ),
      ],
    );
  }
}
