import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/order.dart';
import '../../utils/theme.dart';
import '../../widgets/gradient_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  final LinearGradient _primaryGradient = const LinearGradient(
    colors: [Color.fromARGB(255, 213, 93, 234), Color(0xFF4FC3F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: _primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, yyyy');
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD), // Premium light background
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order ID & Basic Info
            const SizedBox(height: 8),
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(Icons.receipt_long, 'Order Information'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID - ${order.id.length > 10 ? order.id.substring(0, 10).toUpperCase() : order.id.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Placed on ${dateFormat.format(order.orderDate)}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            
            // Products List
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(Icons.shopping_bag_outlined, 'Items in this Order'),
                  const SizedBox(height: 16),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E5F5), // Light purple background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: item.product.imageUrl,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                  child: Text('Variant: ${item.variant} • Qty: ${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 8),
                                Text('₹${(item.product.price * item.quantity).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            
            // Delivery Tracking Timeline
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(Icons.local_shipping_outlined, 'Delivery Status'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Expected by ${dateFormat.format(order.expectedDeliveryDate)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  
                  // Timeline Steps
                  _buildTimelineStep(
                    title: 'Order Placed',
                    isCompleted: order.status.index >= OrderStatus.placed.index,
                    isCurrent: order.status == OrderStatus.placed,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Order Confirmed',
                    isCompleted: order.status.index >= OrderStatus.confirmed.index,
                    isCurrent: order.status == OrderStatus.confirmed,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Packed',
                    isCompleted: order.status.index >= OrderStatus.packed.index,
                    isCurrent: order.status == OrderStatus.packed,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Shipped',
                    isCompleted: order.status.index >= OrderStatus.shipped.index,
                    isCurrent: order.status == OrderStatus.shipped,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Out for Delivery',
                    isCompleted: order.status.index >= OrderStatus.outForDelivery.index,
                    isCurrent: order.status == OrderStatus.outForDelivery,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Delivered',
                    isCompleted: order.status == OrderStatus.delivered,
                    isCurrent: order.status == OrderStatus.delivered,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Delivery Address
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(Icons.location_on, 'Delivery Address'),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5), // Light purple
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.home, color: AppTheme.primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              order.deliveryAddress.isNotEmpty ? order.deliveryAddress : '51/1, kadambur muniappan kovil street, kitchipalayam, salem-15.',
                              style: const TextStyle(height: 1.5, color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            
            // Price Details
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(Icons.payments_outlined, 'Price Details'),
                  const SizedBox(height: 16),
                  _buildPriceRow('List Price', '₹${(order.totalAmount + order.discount).toInt()}'),
                  const SizedBox(height: 12),
                  _buildPriceRow('Discount', '-₹${order.discount.toInt()}', isDiscount: true),
                  const SizedBox(height: 12),
                  _buildPriceRow('Delivery Charges', '₹${order.deliveryFee.toInt()}'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5), // Light purple
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildPriceRow('Total Amount', '₹${order.totalAmount.toInt()}', isTotal: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading Invoice...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppTheme.primaryColor),
                      ),
                      child: const Text('Download Invoice', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: GradientButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Items added to cart for reorder!')),
                        );
                      },
                      padding: EdgeInsets.zero, // Padding handled by SizedBox height
                      borderRadius: 12,
                      child: const Text('Reorder', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({required String title, required bool isCompleted, required bool isCurrent, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column for line and dot
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : (isCurrent ? Colors.green : Colors.transparent),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isCurrent ? Colors.green : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              )
          ],
        ),
        const SizedBox(width: 16),
        // Title
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isCompleted || isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCompleted || isCurrent ? Colors.black87 : Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.green : (isTotal ? Colors.black87 : Colors.black),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
