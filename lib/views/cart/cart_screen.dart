import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_provider.dart';
import '../../utils/mock_data.dart';
import '../../utils/theme.dart';
import '../main_nav.dart';
import 'checkout_screen.dart';
import 'delivery_address_screen.dart';
import '../../widgets/gradient_button.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  const CartScreen({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            if (onBackPressed != null) {
              onBackPressed!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('CART', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5, color: Colors.white)),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeliveryAddressScreen()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.home, size: 18, color: Colors.black87),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Home  51/1, kadambur muniappan kovil...',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  // Big Grey Empty Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Distinct grey background
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_cart, size: 80, color: AppTheme.primaryLight),
                        const SizedBox(height: 24),
                        const Text(
                          'Your Cart is Empty',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 44,
                          child: GradientButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const MainNavScreen()),
                                (route) => false,
                              );
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            borderRadius: 8,
                            child: const Text('Start shopping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Suggested for You
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Suggested for You',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  _buildHorizontalProductList(cartProvider),

                  const SizedBox(height: 16),

                  // Recently Viewed
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Recently Viewed',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  _buildHorizontalProductList(cartProvider, reversed: true),
                  
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF1F3F6), // Light grey background
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Green Banner
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFE8F6F3), // Light mint green
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.currency_rupee, color: Color(0xFF0C9463), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: const Text(
                            'Save ₹35 with Only wrong/defect item returns',
                            style: TextStyle(color: Color(0xFF0C9463), fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cart Items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: item.product.imageUrl,
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              '₹${item.product.discountPrice.toInt()}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '₹${item.product.price.toInt()}',
                                              style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey.shade500, fontSize: 13),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              '5% Off',
                                              style: TextStyle(color: Color(0xFF0C9463), fontWeight: FontWeight.w600, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              height: 32,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: item.product.sizes.contains(item.variant) ? item.variant : (item.product.sizes.isNotEmpty ? item.product.sizes.first : 'Default'),
                                                  icon: const Padding(
                                                    padding: EdgeInsets.only(left: 4.0),
                                                    child: Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                                  ),
                                                  isDense: true,
                                                  menuMaxHeight: 250,
                                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      cartProvider.updateVariant(item.id, newValue);
                                                    }
                                                  },
                                                  items: item.product.sizes.isNotEmpty 
                                                    ? item.product.sizes.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('Size: $value'),
                                                        );
                                                      }).toList()
                                                    : [
                                                        const DropdownMenuItem<String>(
                                                          value: 'Default',
                                                          child: Text('Size: Default'),
                                                        )
                                                      ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              height: 32,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<int>(
                                                  value: item.quantity,
                                                  icon: const Padding(
                                                    padding: EdgeInsets.only(left: 4.0),
                                                    child: Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                                                  ),
                                                  isDense: true,
                                                  menuMaxHeight: 250,
                                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                                                  onChanged: (int? newValue) {
                                                    if (newValue != null) {
                                                      cartProvider.updateQuantity(item.id, newValue);
                                                    }
                                                  },
                                                  items: List.generate(10, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                                                    return DropdownMenuItem<int>(
                                                      value: value,
                                                      child: Text('Qty: $value'),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text('All issue easy returns', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.local_shipping, size: 16, color: Colors.grey.shade600),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text('Estimated Delivery by Wed, 30th Sep', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 1),
                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite_border, color: Colors.black54, size: 20),
                                    label: const Text('Move to Wishlist', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                Container(width: 1, height: 40, color: Colors.grey.shade200),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () => cartProvider.removeItem(item.id),
                                    icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                                    label: const Text('Remove', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Wishlist row
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite_border, color: Colors.black87),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Wishlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),

                  // Price Details
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 24),
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price Details (${cartProvider.items.length} Item${cartProvider.items.length > 1 ? 's' : ''})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Product Price', '+ ₹${cartProvider.productTotal.toInt()}'),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Total Discounts', '- ₹${cartProvider.discountAmount.toInt()}', color: const Color(0xFF0C9463)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1, thickness: 1),
                        ),
                        _buildSummaryRow('Order Total', '₹${cartProvider.finalTotal.toInt()}', isTotal: true),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F6F3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.discount, color: Color(0xFF0C9463), size: 16),
                              const SizedBox(width: 8),
                              Text('Yay! Your total discount is ₹${cartProvider.discountAmount.toInt()}', style: const TextStyle(color: Color(0xFF0C9463), fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${cartProvider.finalTotal.toInt()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('VIEW PRICE DETAILS', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GradientButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        borderRadius: 4,
                        child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalProductList(CartProvider cartProvider, {bool reversed = false}) {
    // Get products from mock data
    List products = List.from(MockData.products);
    if (reversed) {
      products = products.reversed.toList();
    }
    
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6, // Just show a few for suggestion
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '₹${product.price.toInt()}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹${product.discountPrice.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: OutlinedButton(
                          onPressed: () {
                            cartProvider.addToCart(product, 'Default', 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.name} added to cart')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Add to cart', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
