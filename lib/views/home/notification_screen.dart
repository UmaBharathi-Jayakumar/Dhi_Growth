import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD), // Premium light grey background
      appBar: AppBar(
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all as read', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12, top: 4),
            child: Text('Today', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          _buildPremiumNotificationCard(
            icon: Icons.local_shipping,
            color: Colors.green,
            title: 'Order Delivered Successfully',
            subtitle: 'Your order #DG102938 has been delivered. Tap to review.',
            time: '2 hours ago',
            isNew: true,
          ),
          _buildPremiumNotificationCard(
            icon: Icons.local_offer,
            color: Colors.orange,
            title: 'Mega Fashion Sale is Live!',
            subtitle: 'Get up to 60% off on all Fashion products. Shop now!',
            time: '5 hours ago',
            isNew: true,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text('Earlier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          _buildPremiumNotificationCard(
            icon: Icons.shopping_bag,
            color: Colors.blue,
            title: 'Items in your cart are waiting',
            subtitle: 'Complete your purchase before they go out of stock.',
            time: '2 days ago',
            isNew: false,
          ),
          _buildPremiumNotificationCard(
            icon: Icons.star,
            color: Colors.amber,
            title: 'Earn 100 SuperCoins',
            subtitle: 'Leave a review for your recent purchase and earn rewards.',
            time: '1 week ago',
            isNew: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumNotificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isNew 
            ? Border.all(color: color.withOpacity(0.3), width: 1.5) 
            : Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                            ),
                          ),
                          if (isNew)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
