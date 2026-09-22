import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../widgets/gradient_button.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light grey background
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Select Delivery Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add new address button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  _showLocationBottomSheet(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.add_box_outlined, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Text('Add new address', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            
            // Saved addresses title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Saved addresses', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
            ),
            
            // Saved address card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home_outlined, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('HOME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('Selected', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const Spacer(),
                            const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '51/1,kadambur muniappan kovil\nstreet,kitchipalayam,salem-15., Kitchipaly...',
                          style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 14, color: Colors.black54),
                            const SizedBox(width: 4),
                            const Text('9080762937', style: TextStyle(color: Colors.black54, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top illustration area
              Container(
                width: double.infinity,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F4F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Placeholder for 3D illustration
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delivery_dining, size: 80, color: AppTheme.primaryLight),
                        const SizedBox(height: 8),
                        const Icon(Icons.location_on, size: 30, color: Colors.blue),
                      ],
                    ),
                    // Close button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                            ]
                          ),
                          child: const Icon(Icons.close, size: 18, color: Colors.black54),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Where do you want us to\ndeliver this order?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Help us find the nearest store for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    
                    // Use current location button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: GradientButton(
                        onPressed: () {
                          Navigator.pop(context); // Close sheet
                        },
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        borderRadius: 12,
                        child: const Text('Use current location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Away from my location button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close sheet
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Away from my location', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
