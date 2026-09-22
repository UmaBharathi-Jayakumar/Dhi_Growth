import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/cart_provider.dart';
import '../../models/product.dart';
import '../../utils/theme.dart';
import '../cart/checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedVariant;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isEmpty) {
      _selectedVariant = 'Default';
    }
  }

  Widget _buildRatingBar(String label, int count, int total, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700))),
          Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: total == 0 ? 0 : count / total,
                child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
              ),
            ),
          ),
          SizedBox(width: 16, child: Text(count.toString(), style: TextStyle(fontSize: 12, color: Colors.grey.shade700), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildReviewItem({required int rating, required Color ratingColor, required String title, required String date, required String content, required String author, int helpfulCount = 0}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: ratingColor, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Text(rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: Colors.white, size: 10),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(' • Posted on $date', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: content,
              style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
              children: [
                if (content.endsWith('...'))
                  const TextSpan(text: 'Read More', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(author, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(helpfulCount > 0 ? 'Helpful ($helpfulCount)' : 'Helpful', style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 8, color: const Color(0xFFF1F3F6)),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          child: Text('Customer Ratings & Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating Box
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F9D58),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('4.1', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.star, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Text('10 ratings', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('2 reviews', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Rating Bars
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar('Very Good', 6, 10, const Color(0xFF0F9D58)),
                    _buildRatingBar('Good', 0, 10, Colors.grey.shade300),
                    _buildRatingBar('Ok-Ok', 3, 10, const Color(0xFFF4B400)),
                    _buildRatingBar('Bad', 1, 10, const Color(0xFFDB4437)),
                    _buildRatingBar('Very Bad', 0, 10, Colors.grey.shade300),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Review Items
        _buildReviewItem(
          rating: 5,
          ratingColor: const Color(0xFF0F9D58),
          title: 'Very Good',
          date: '19 Jul, 2026',
          content: 'It\'s a beautiful skirt co ord set. Perfect for summer wear. Fabric is cotton n...',
          author: '~Simi saluja',
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        _buildReviewItem(
          rating: 3,
          ratingColor: const Color(0xFFF4B400),
          title: 'Ok-Ok',
          date: '12 Jul, 2026',
          content: 'Ok\n',
          author: '~Ankita Saha',
          helpfulCount: 2,
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('VIEW ALL REVIEWS', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                  child: const Icon(Icons.chevron_right, color: Colors.white, size: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(height: 8, color: const Color(0xFFF1F3F6)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Hero(
              tag: 'product_image_${widget.product.id}',
              child: CachedNetworkImage(
                imageUrl: widget.product.imageUrl,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.product.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.reviewCount} reviews',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${widget.product.discountPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${widget.product.price.toInt()}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${widget.product.discountPercent.toInt()}% OFF',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'Product Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sizes / Variants
                  if (widget.product.sizes.isNotEmpty) ...[
                    Text(
                      'Select Size',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.product.sizes.map((size) {
                        final isSelected = _selectedVariant == size;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedVariant = size;
                              });
                            }
                          },
                          selectedColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            _buildReviewSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Delivery Block
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          text: 'Delivery by ',
                          style: TextStyle(color: Colors.black87, fontSize: 15),
                          children: [
                            TextSpan(text: 'Thu, 1 Oct\n', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'at 636015', style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Change', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (widget.product.sizes.isNotEmpty && _selectedVariant == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a size first!')),
                            );
                            return;
                          }
                          context.read<CartProvider>().addToCart(
                                widget.product,
                                _selectedVariant ?? 'Default',
                                _quantity,
                              );
                          final snackbarText = widget.product.sizes.isNotEmpty
                              ? 'Added ${widget.product.name} (Size: $_selectedVariant) to Cart!'
                              : 'Added ${widget.product.name} to Cart!';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(snackbarText)),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(color: Colors.purple),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shopping_cart_outlined, color: Colors.purple, size: 20),
                            SizedBox(width: 8),
                            Text('Add to Cart', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientButton(
                        onPressed: () {
                          if (widget.product.sizes.isNotEmpty && _selectedVariant == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a size first!')),
                            );
                            return;
                          }
                          context.read<CartProvider>().addToCart(
                                widget.product,
                                _selectedVariant ?? 'Default',
                                _quantity,
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        borderRadius: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.double_arrow, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text('Buy Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
