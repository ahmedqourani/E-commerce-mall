import 'package:e_commerce_mall/core/constants/app_colors.dart';
import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/utils/money.dart';
import 'package:e_commerce_mall/features/orderHistory/data/models/order_model.dart';
import 'package:e_commerce_mall/shared/custom_button.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
    this.onReOrder,
  });

  final OrderModel order;
  final VoidCallback? onReOrder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              text: 'Order #${order.id}',
              size: 18,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 10),

                // Display every product in the order, not only the first one.
            ...order.products.map((product) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      product.thumbnail,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: colors.surfaceMuted,
                          child: Icon(
                            Icons.broken_image,
                            color: colors.textMuted,
                            size: 40,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: product.title,
                            size: 18,
                            weight: FontWeight.bold,
                          ),
                          CustomText(
                            text: 'Qty × ${product.quantity}',
                            size: 16,
                          ),
                          CustomText(
                            text: Money.format(product.price),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Divider(),
            CustomText(
              text: '${AppStrings.total} : ${Money.format(order.total)}',
              size: 18,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 11),

            CustomButton(
              text: AppStrings.reorder,
              color: colors.primary,
              size: 20,
              onTap: onReOrder,
            ),
          ],
        ),
      ),
    );
  }
}
