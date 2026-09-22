import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_provider.dart';
import '../../controllers/order_provider.dart';
import '../../widgets/gradient_button.dart';
import '../orders/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  final String _dummyAddress = 'UMMS\nCoimbatore, Tamil Nadu, 641001';
  
  final LinearGradient _primaryGradient = const LinearGradient(
    colors: [Color.fromARGB(255, 213, 93, 234), Color(0xFF4FC3F7)], // Lighter purple to light blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Address
                        _buildSectionHeader(Icons.location_on, 'Delivery Address'),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E5F5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on, color: Color(0xFF7B1FA2)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Ammu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('Coimbatore, Tamil\nNadu, 641001', style: TextStyle(color: Colors.grey.shade600, height: 1.3)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E5F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, size: 14, color: Color(0xFF7B1FA2)),
                                    SizedBox(width: 4),
                                    Text('Change', style: TextStyle(color: Color(0xFF7B1FA2), fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Payment Method
                        _buildSectionHeader(Icons.credit_card, 'Payment Method'),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildPaymentOption(
                                'UPI (GPay, PhonePe, Paytm)',
                                'Pay using any UPI app',
                                'UPI',
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('UPI', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.grey)),
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade100),
                              _buildPaymentOption(
                                'Credit / Debit / ATM Card',
                                'Pay securely with your card',
                                'Card',
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.credit_card, color: Colors.blue),
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade100),
                              _buildPaymentOption(
                                'Cash on Delivery (COD)',
                                'Pay when you receive',
                                'COD',
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.money, color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Order Summary
                        _buildSectionHeader(Icons.receipt_long, 'Order Summary'),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _buildSummaryRow('Product Total', '₹${cartProvider.productTotal.toInt()}'),
                                    const SizedBox(height: 8),
                                    _buildSummaryRow('Discount', '-₹${cartProvider.discountAmount.toInt()}', color: Colors.green),
                                    const SizedBox(height: 8),
                                    _buildSummaryRow('Delivery Fee', '₹${cartProvider.deliveryFee.toInt()}'),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E5F5),
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7B1FA2))),
                                    Text('₹${cartProvider.finalTotal.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF7B1FA2))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Place Order Button (Fixed at bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FD),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF6F8FD).withOpacity(0.0),
                    const Color(0xFFF6F8FD),
                    const Color(0xFFF6F8FD),
                  ],
                ),
              ),
              child: GradientButton(
                onPressed: () {
                  final orderProvider = context.read<OrderProvider>();
                  orderProvider.placeOrder(cartProvider, _dummyAddress);
                  final newOrder = orderProvider.orders.first;
                  cartProvider.clearCart();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrderSuccessScreen(orderId: newOrder.id)),
                  );
                },
                padding: const EdgeInsets.symmetric(vertical: 16),
                borderRadius: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Place Order (₹${cartProvider.finalTotal.toInt()})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 16),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1C2E),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              height: 3,
              width: 30,
              decoration: BoxDecoration(
                gradient: _primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, String value, Widget iconWidget) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E5F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF9C27B0), width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF9C27B0) : Colors.grey.shade400,
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            iconWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D1C2E))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF0D1C2E),
          ),
        ),
      ],
    );
  }
}

class CheckoutHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height + 40, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
