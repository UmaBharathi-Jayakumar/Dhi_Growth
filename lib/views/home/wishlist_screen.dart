import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_provider.dart';
import '../../utils/mock_data.dart';
import '../../utils/theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/gradient_button.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Wishlist', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final wishlistIds = provider.wishlistIds;
          
          if (wishlistIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 80, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your wishlist is empty!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Explore more and shortlist some items\nto buy them later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: GradientButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          }

          final wishlistedProducts = MockData.products.where((p) => wishlistIds.contains(p.id)).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${wishlistedProducts.length} Items',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(product: wishlistedProducts[index]);
                    },
                    childCount: wishlistedProducts.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
