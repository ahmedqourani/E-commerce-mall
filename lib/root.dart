import 'package:e_commerce_mall/core/constants/app_colors.dart';
import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/features/auth/view/profile_view.dart';
import 'package:e_commerce_mall/features/cart/views/cart_view.dart';
import 'package:e_commerce_mall/features/favorite/views/favorite_view.dart';
import 'package:e_commerce_mall/features/home/views/home_view.dart';
import 'package:e_commerce_mall/features/orderHistory/views/order_history_view.dart';
import 'package:flutter/material.dart';

/// The five-tab shell: Home, Favorite, Cart, Order History, Profile.
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late PageController controller;
  late List<Widget> screens;
  int currentScreen = 0;

  @override
  void initState() {
    screens = [
      HomeView(),
      FavoriteView(),
      CartView(),
      OrderHistoryView(),
      ProfileView(),
    ];
    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      // The bar reads as a surface lifted off the page: the card tone plus a
      // single hairline along the top. The two are adjacent near-white values,
      // so the hairline is what carries the separation — no radius, no shadow
      // and no floating pill, all of which put a visible seam across the bottom
      // of every screen.
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: SafeArea(
          top: false,
          // Colors, label sizes and weights come from
          // `AppTheme.bottomNavigationBarTheme`: the accent at its readable step
          // for the selected item, muted neutral for the rest.
          child: BottomNavigationBar(
            currentIndex: currentScreen,
            onTap: (value) {
              setState(() {
                currentScreen = value;
              });
              controller.jumpToPage(currentScreen);
            },
            // One icon family, outlined at rest and filled when active, so the
            // selected tab is legible without leaning on color alone.
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                activeIcon: Icon(Icons.favorite_rounded),
                label: AppStrings.favorite,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag_rounded),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long_rounded),
                label: AppStrings.orders,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
