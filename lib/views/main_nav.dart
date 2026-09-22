import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_provider.dart';
import '../utils/theme.dart';
import 'cart/cart_screen.dart';
import 'categories/categories_screen.dart';
import 'home/home_screen.dart';
import 'orders/orders_list_screen.dart';
import 'profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      CategoriesScreen(onBackPressed: () => setState(() => _currentIndex = 0)), // Go to Home
      CartScreen(onBackPressed: () => setState(() => _currentIndex = 1)), // Go to Categories
      OrdersListScreen(onBackPressed: () => setState(() => _currentIndex = 2)), // Go to Cart
      ProfileScreen(onBackPressed: () => setState(() => _currentIndex = 3)), // Go to Orders
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.category_outlined, Icons.category, 'Categories'),
              _buildCartNavItem(2),
              _buildNavItem(3, Icons.local_shipping_outlined, Icons.local_shipping, 'Orders'),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.purple : Colors.grey.shade600,
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCartNavItem(int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                  color: isSelected ? Colors.purple : Colors.grey.shade600,
                  size: 26,
                ),
                Positioned(
                  right: -5,
                  top: -5,
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.itemCount == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Text(
                'Cart',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

