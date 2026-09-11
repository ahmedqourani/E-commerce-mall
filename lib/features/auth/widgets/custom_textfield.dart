import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield({required this.labelText, required this.controller});
  final String labelText;
  final TextEditingController controller;

  /// Same radius for every state so the field never changes shape on focus.
  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sits directly on the immersive profile screen with no fill, so the outline
    // and label have to read against the near-black behind them.
    final colors = context.colors;

    return TextField(
      controller: controller,
      cursorColor: colors.primaryAccent,
      style: TextStyle(color: colors.onBrand),
      decoration: InputDecoration(
        labelText: labelText,
        // Was off-white for both states, which gave the label the same weight as
        // the value it describes. Muted at rest, accent once focused.
        labelStyle: TextStyle(color: colors.textSecondary),
        floatingLabelStyle: TextStyle(color: colors.primaryAccent),
        enabledBorder: _border(colors.borderStrong),
        // Was identical to the enabled border, so focus was invisible.
        focusedBorder: _border(colors.primary, width: 2),
        errorBorder: _border(colors.error),
        focusedErrorBorder: _border(colors.error, width: 2),
        errorStyle: TextStyle(
          color: colors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
