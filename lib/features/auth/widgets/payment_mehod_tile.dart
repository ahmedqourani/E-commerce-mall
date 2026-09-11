import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';

class PaymentMethodTile extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodTile({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Sits on the immersive profile screen; `brandTileFill` is the raised step
    // that separates it from the near-black behind without adding a color.
    final colors = context.colors;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      tileColor: colors.brandTileFill,
      title: CustomText(text: 'Debit card', size: 15, color: colors.onBrand),
      // Was the same off-white as the title, so the card number competed with
      // the label naming it.
      subtitle: CustomText(
        text: '3566**** ****0505',
        size: 15,
        color: colors.onBrandMuted,
      ),
      trailing: Radio<String>(
        fillColor: WidgetStateProperty.resolveWith((states) {
          // Selected is the one state worth spending the accent on.
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.onBrandSubtle;
        }),
        value: 'Visa',
        groupValue: selectedMethod,
        onChanged: onChanged,
      ),
      leading: Image.asset('assets/icon/visa icon.png', width: 50, height: 70),
    );
  }
}
