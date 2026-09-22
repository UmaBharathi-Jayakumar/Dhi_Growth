import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../widgets/gradient_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controllers/order_provider.dart';
import '../../utils/theme.dart';
import 'order_details_screen.dart';

class OrdersListScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const OrdersListScreen({super.key, this.onBackPressed});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  int _currentBannerIndex = 0;
  final PageController _pageController = PageController();
  Timer? _timer;
  String _selectedCategory = 'All';
  List<String> _selectedStatuses = [];
  String _selectedTime = '';
  
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentBannerIndex < _banners.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
  
  final List<Map<String, String>> _banners = [
    {
      'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&q=80',
      'title': 'Earn 100 SuperCoins\nSign up now',
    },
    {
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&q=80',
      'title': 'Mega Fashion Sale\nUp to 60% Off',
    },
    {
      'image': 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&q=80',
      'title': 'Electronics Week\nGrab Best Deals',
    },
    {
      'image': 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=800&q=80',
      'title': 'Home Essentials\nStarting at ₹99',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('My Orders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Promotional Banners Carousel
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                        itemCount: _banners.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(_banners[index]['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('DhiGrowth EXCLUSIVE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                  const SizedBox(height: 8),
                                  Text(_banners[index]['title']!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Banner Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_banners.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 4,
                          width: _currentBannerIndex == index ? 24 : 12,
                          decoration: BoxDecoration(
                            color: _currentBannerIndex == index ? AppTheme.primaryColor : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Search Bar and Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search your...',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => _showFiltersBottomSheet(context),
                        child: Row(
                          children: [
                            const Icon(Icons.tune, color: Colors.black87, size: 20),
                            const SizedBox(width: 6),
                            const Text('Filters', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
                // Categories Scroll
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildChip('All'),
                      const SizedBox(width: 8),
                      _buildChip('Fashion'),
                      const SizedBox(width: 8),
                      _buildChip('Electronics'),
                      const SizedBox(width: 8),
                      _buildChip('Beauty'),
                      const SizedBox(width: 8),
                      _buildChip('Home'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 4, color: Color(0xFFF1F3F6), height: 0),
              ],
            ),
          ),
          
          // Orders List
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              final dateFormat = DateFormat('MMM dd');

              var displayOrders = orderProvider.orders;
              
              if (_selectedCategory != 'All') {
                displayOrders = displayOrders.where((order) {
                  return order.items.any((item) => item.product.category.toLowerCase() == _selectedCategory.toLowerCase());
                }).toList();
              }

              if (_selectedStatuses.isNotEmpty) {
                displayOrders = displayOrders.where((order) {
                  if (_selectedStatuses.contains('On the way') && (order.status == OrderStatus.shipped || order.status == OrderStatus.outForDelivery)) return true;
                  if (_selectedStatuses.contains('Delivered') && order.status == OrderStatus.delivered) return true;
                  if (_selectedStatuses.contains('Cancelled') && order.status.name == 'cancelled') return true;
                  if (_selectedStatuses.contains('Returned') && order.status.name == 'returned') return true;
                  return false;
                }).toList();
              }

              if (_selectedTime.isNotEmpty) {
                final now = DateTime.now();
                displayOrders = displayOrders.where((order) {
                  if (_selectedTime == 'Last 30 days') {
                    return order.orderDate.isAfter(now.subtract(const Duration(days: 30)));
                  } else if (_selectedTime == '2024') {
                    return order.orderDate.year == 2024;
                  } else if (_selectedTime == '2023') {
                    return order.orderDate.year == 2023;
                  } else if (_selectedTime == 'Older') {
                    return order.orderDate.year < 2023;
                  }
                  return true;
                }).toList();
              }

              if (displayOrders.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text('No orders found for $_selectedCategory', style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Show actual real orders
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final order = displayOrders[index];
                    return _buildRealOrderCard(context, order, dateFormat);
                  },
                  childCount: displayOrders.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E5F5) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMockOrderCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imageUrl,
    OrderModel? realOrder,
  }) {
    return InkWell(
      onTap: () {
        // Mock order tap behavior
        if (realOrder != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: realOrder)),
          );
        } else {
          // If it's a mock order, just show a snackbar or navigate with a fake order
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This is a mock order.')));
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200)
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Product Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(Icons.chevron_right, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 4, color: Color(0xFFF1F3F6), height: 0),
        ],
      ),
    );
  }

  Widget _buildRealOrderCard(BuildContext context, OrderModel order, DateFormat dateFormat) {
    bool isDelivered = order.status == OrderStatus.delivered;
    String statusText = isDelivered ? 'Delivered on ${dateFormat.format(order.expectedDeliveryDate)}' : '${_getStatusText(order.status)} on ${dateFormat.format(order.expectedDeliveryDate)}';
    
    String productName = 'Order #${order.id.substring(0, 8)}';
    String imageUrl = 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=200&q=80';
    
    if (order.items.isNotEmpty) {
      productName = order.items.first.product.name;
      imageUrl = order.items.first.product.imageUrl;
      if (order.items.length > 1) {
        productName = '${order.items.first.product.name} (+${order.items.length - 1} items)';
      }
    }

    return _buildMockOrderCard(
      context: context,
      title: statusText,
      subtitle: productName,
      imageUrl: imageUrl,
      realOrder: order, // Pass the real order so onTap works!
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    List<String> tempStatuses = List.from(_selectedStatuses);
    String tempTime = _selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          setModalState(() {
                            tempStatuses.clear();
                            tempTime = '';
                          });
                        },
                        child: Text('Clear Filter', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Order Status
                  const Text('Order Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildFilterChip('On the way', tempStatuses.contains('On the way'), () {
                        setModalState(() {
                          tempStatuses.contains('On the way') ? tempStatuses.remove('On the way') : tempStatuses.add('On the way');
                        });
                      }),
                      _buildFilterChip('Delivered', tempStatuses.contains('Delivered'), () {
                        setModalState(() {
                          tempStatuses.contains('Delivered') ? tempStatuses.remove('Delivered') : tempStatuses.add('Delivered');
                        });
                      }),
                      _buildFilterChip('Cancelled', tempStatuses.contains('Cancelled'), () {
                        setModalState(() {
                          tempStatuses.contains('Cancelled') ? tempStatuses.remove('Cancelled') : tempStatuses.add('Cancelled');
                        });
                      }),
                      _buildFilterChip('Returned', tempStatuses.contains('Returned'), () {
                        setModalState(() {
                          tempStatuses.contains('Returned') ? tempStatuses.remove('Returned') : tempStatuses.add('Returned');
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Order Time
                  const Text('Order Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildFilterChip('Last 30 days', tempTime == 'Last 30 days', () {
                        setModalState(() => tempTime = tempTime == 'Last 30 days' ? '' : 'Last 30 days');
                      }),
                      _buildFilterChip('2024', tempTime == '2024', () {
                        setModalState(() => tempTime = tempTime == '2024' ? '' : '2024');
                      }),
                      _buildFilterChip('2023', tempTime == '2023', () {
                        setModalState(() => tempTime = tempTime == '2023' ? '' : '2023');
                      }),
                      _buildFilterChip('Older', tempTime == 'Older', () {
                        setModalState(() => tempTime = tempTime == 'Older' ? '' : 'Older');
                      }),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GradientButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatuses = List.from(tempStatuses);
                              _selectedTime = tempTime;
                            });
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          borderRadius: 8,
                          child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E5F5) : Colors.white,
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isSelected ? label : '$label +', 
          style: TextStyle(
            color: isSelected ? AppTheme.primaryColor : Colors.black87, 
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
          )
        ),
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed: return 'Placed';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.packed: return 'Packed';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered: return 'Delivered';
    }
  }
}
