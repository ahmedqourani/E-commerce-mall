import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/core/utils/money.dart';
import 'package:e_commerce_mall/features/cart/data/models/cart_model.dart';
import 'package:e_commerce_mall/features/cart/data/repositories/cart_repo.dart';
import 'package:e_commerce_mall/features/cart/widgets/cart_item.dart';
import 'package:e_commerce_mall/features/checkout/views/checkout_view.dart';
import 'package:e_commerce_mall/shared/empty_state.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartRepo cartRepo = CartRepo();
  CartModel? cart;
  bool isLoading = false;

  /// Was swallowed silently, which made a failed request look like an empty
  /// cart. The screen now distinguishes the two.
  String? error;

  Future<void> getCart() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final result = await cartRepo.getCart();
      if (!mounted) return;
      setState(() => cart = result);
    } catch (e) {
      if (!mounted) return;
      setState(
        () => error = e is ApiError ? e.message : AppStrings.loadCartFailed,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  double get totalPrice {
    final products = cart?.products;
    if (products == null || products.isEmpty) return 0;
    return products.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  int get itemCount =>
      cart?.products.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;

  @override
  void initState() {
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    final products = cart?.products ?? const [];

    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (error != null) {
              return EmptyState(
                icon: Icons.cloud_off_rounded,
                title: AppStrings.loadCartFailed,
                message: error,
                actionLabel: AppStrings.retry,
                onAction: getCart,
              );
            }
            // The old screen built a zero-length list here, so an empty cart
            // was an entirely blank page under a Checkout button.
            if (products.isEmpty) {
              return const EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: AppStrings.emptyCartTitle,
                message: AppStrings.emptyCartBody,
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return CartItem(
                        image: product.thumbnail,
                        text: product.title,
                        desc: Money.format(product.price),
                        quantity: product.quantity,
                        onAdd: () => setState(() => product.quantity++),
                        onMinus: () {
                          if (product.quantity > 1) {
                            setState(() => product.quantity--);
                          }
                        },
                        onRemove: () =>
                            setState(() => products.removeAt(index)),
                      );
                    },
                  ),
                ),
                _CartSummaryBar(
                  total: totalPrice,
                  itemCount: itemCount,
                  onCheckout: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutView(
                          subtotal: totalPrice,
                          itemCount: itemCount,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppStrings.total} · ${AppStrings.itemCount(itemCount)}',
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
              const SizedBox(height: 3),
              Text(
                Money.format(total),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              AppStrings.checkout,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
