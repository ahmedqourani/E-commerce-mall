import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/features/orderHistory/data/models/order_model.dart';
import 'package:e_commerce_mall/features/orderHistory/data/repositories/oreder_repo.dart';
import 'package:e_commerce_mall/features/orderHistory/widgets/order_item.dart';
import 'package:e_commerce_mall/shared/empty_state.dart';
import 'package:flutter/material.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  final OrderRepo orderRepo = OrderRepo();

  List<OrderModel> orders = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> getOrders({bool showLoader = true}) async {
    try {
      setState(() {
        if (showLoader) isLoading = true;
        errorMessage = null;
      });

      final result = await orderRepo.getOrders();

      if (!mounted) return;

      setState(() {
        // Exclude empty orders so the list contains no blank entries.
        orders = result.where((order) => order.products.isNotEmpty).toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e is ApiError ? e.message : AppStrings.loadOrdersFailed;
      });
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> reOrder(OrderModel order) async {
    try {
      await orderRepo.reOrder(order);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.success,
          content: Text(
            AppStrings.reorderSuccess,
            style: TextStyle(color: context.colors.onSuccess),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          content: Text(
            e is ApiError ? e.message : AppStrings.reorderFailed,
            style: TextStyle(color: context.colors.onError),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.orderHistory)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return EmptyState(
        icon: Icons.cloud_off_rounded,
        title: AppStrings.loadOrdersFailed,
        message: errorMessage,
        actionLabel: AppStrings.retry,
        onAction: getOrders,
      );
    }

    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => getOrders(showLoader: false),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            EmptyState(
              icon: Icons.receipt_long_outlined,
              title: AppStrings.noOrdersTitle,
              message: AppStrings.noOrdersBody,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getOrders(showLoader: false),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return OrderItem(
            order: order,
            onReOrder: () => reOrder(order),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 5);
        },
      ),
    );
  }
}
