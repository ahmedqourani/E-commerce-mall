import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/shared/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    required this.quantity,
    this.onAdd,
    this.onMinus,
    this.onRemove,
  });

  final String image;
  final String text;
  final String desc;
  final int quantity;

  final VoidCallback? onAdd;
  final VoidCallback? onMinus;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 6,
                    shadowColor: colors.shadowStrong,
                    borderRadius: BorderRadius.circular(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        image,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: text,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  CustomText(text: desc, size: 15),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: onAdd,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colors.primary,
                        child: Icon(
                          CupertinoIcons.add,
                          size: 18,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomText(text: '$quantity', size: 18),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onMinus,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colors.primary,
                        child: Icon(
                          CupertinoIcons.minus,
                          size: 18,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colors.primary,
                    ),
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}