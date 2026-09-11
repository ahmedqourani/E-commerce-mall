import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/core/utils/money.dart';
import 'package:e_commerce_mall/features/checkout/widgets/checkout_widget.dart';
import 'package:e_commerce_mall/shared/custom_button.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';
import 'package:flutter/material.dart';

/// Order review and payment.
///
/// The money shown here is the real cart total passed in by [CartView] — the
/// screen used to display four hardcoded amounts (`$16.48`, `$0.3`, `$1.5`,
/// `$18.19`) that had no relationship to what was in the cart.
///
/// The catalogue API carries no tax or shipping data, so those two lines are
/// app-side estimates derived from the named constants below and labelled as
/// estimates. They are the only figures on this screen not taken from the cart.
class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.subtotal,
    required this.itemCount,
  });

  /// Sum of `price × quantity` across the cart.
  final double subtotal;
  final int itemCount;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  /// No tax or shipping figures come back from the API, so these are the app's
  /// own stated assumptions rather than data dressed up as the server's.
  static const double _taxRate = 0.07;
  static const double _shippingFee = 4.99;
  static const String _deliveryEstimate = '3 – 5 business days';

  String selectedMethod = 'Cash';
  bool saveCard = true;

  double get taxes => widget.subtotal * _taxRate;

  double get total => widget.subtotal + taxes + _shippingFee;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCash = selectedMethod == 'Cash';
    final isVisa = selectedMethod == 'Visa';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: AppStrings.checkout,
          size: 18,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: AppStrings.orderSummary,
                size: 20,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 10),

              CheckoutWidget(
                text: '${AppStrings.subtotal} · '
                    '${AppStrings.itemCount(widget.itemCount)}',
                price: Money.format(widget.subtotal),
              ),
              CheckoutWidget(
                text: AppStrings.taxes,
                price: Money.format(taxes),
              ),
              CheckoutWidget(
                text: AppStrings.shippingFee,
                price: Money.format(_shippingFee),
              ),
              const SizedBox(height: 10),
              const Divider(),
              CheckoutWidget(
                text: '${AppStrings.total}:',
                price: Money.format(total),
                weight: FontWeight.w900,
                color: colors.textPrimary,
              ),
              const SizedBox(height: 15),
              // Was "Estimated delivery time / 15 - 30 mins" — a courier window
              // that only makes sense for one kind of order.
              CheckoutWidget(
                text: AppStrings.estimatedDelivery,
                price: _deliveryEstimate,
                weight: FontWeight.w900,
                color: colors.textPrimary,
                size: 12,
              ),
              const SizedBox(height: 60),

              const CustomText(text: AppStrings.paymentMethods, size: 25),
              const SizedBox(height: 17),

              // A RadioGroup ancestor, replacing the per-Radio groupValue and
              // onChanged that Flutter deprecated.
              RadioGroup<String>(
                groupValue: selectedMethod,
                onChanged: (value) {
                  if (value != null) setState(() => selectedMethod = value);
                },
                child: Column(
                  children: [
                    // The tile fill reflects the selected method instead of
                    // being a static off-brand fill.
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 16,
                      ),
                      tileColor: isCash ? colors.primary : colors.surfaceMuted,
                      title: CustomText(
                        text: AppStrings.cashOnDelivery,
                        size: 18,
                        color: isCash ? colors.onPrimary : colors.textPrimary,
                      ),
                      trailing: Radio<String>(
                        fillColor: WidgetStateProperty.all(
                          isCash ? colors.onPrimary : colors.borderStrong,
                        ),
                        value: 'Cash',
                      ),
                      leading: Image.asset(
                        'assets/icon/icon.png',
                        width: 50,
                        height: 70,
                      ),
                      onTap: () => setState(() => selectedMethod = 'Cash'),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 16,
                      ),
                      tileColor: isVisa ? colors.primary : colors.surfaceMuted,
                      title: CustomText(
                        text: AppStrings.debitCard,
                        size: 15,
                        color: isVisa ? colors.onPrimary : colors.textPrimary,
                      ),
                      subtitle: CustomText(
                        text: '3566**** ****0505',
                        size: 15,
                        color:
                            isVisa ? colors.onPrimary : colors.textSecondary,
                      ),
                      trailing: Radio<String>(
                        fillColor: WidgetStateProperty.all(
                          isVisa ? colors.onPrimary : colors.borderStrong,
                        ),
                        value: 'Visa',
                      ),
                      leading: Image.asset(
                        'assets/icon/visa icon.png',
                        width: 50,
                        height: 70,
                      ),
                      onTap: () => setState(() => selectedMethod = 'Visa'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  // Colors come from the themed CheckboxTheme (primary fill).
                  Checkbox(
                    value: saveCard,
                    onChanged: (v) => setState(() => saveCard = v ?? false),
                  ),
                  const Expanded(
                    child: CustomText(text: AppStrings.saveCard, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: colors.shadowStrong,
                offset: const Offset(0, -3),
                blurRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: AppStrings.total, size: 22),
                  const SizedBox(height: 3),
                  CustomText(text: Money.format(total), size: 22),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: AppStrings.payNow,
                onTap: () => _showSuccessDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colors.primary,
                  child: Icon(Icons.check, color: colors.onPrimary, size: 40),
                ),
                const SizedBox(height: 20),
                const CustomText(
                  text: AppStrings.paymentSuccess,
                  size: 25,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                CustomText(
                  text: AppStrings.paymentSuccessBody,
                  size: 13,
                  color: colors.textSecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.paymentReceiptBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  size: 20,
                  text: AppStrings.close,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
