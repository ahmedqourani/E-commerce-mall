import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.text, this.onTap, this.color, this.size});
  final String text;
  final Function()? onTap;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 180,
        decoration: BoxDecoration(
          color: color ?? colors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomText(
            text: text,
            size: size ?? 25,
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
