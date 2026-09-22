import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/product_card.dart';
import '../search/search_screen.dart';
import 'notification_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 213, 93, 234),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.shopping_bag, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Text(
              'DhiGrowth',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Seamless Purple Header for Search & Categories
            ClipPath(
              clipper: WaveClipper(),
              child: CustomPaint(
                foregroundPainter: WaveBorderPainter(),
                child: Container(
                padding: const EdgeInsets.only(bottom: 48), // Extra padding for the wave
                color: const Color.fromARGB(255, 213, 93, 234),
                child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 4, right: 12, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 245, 235, 248),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search, color: AppTheme.primaryColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search products, brands...',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.mic_none, color: AppTheme.primaryColor, size: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Image-like Categories
                  Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      final categories = [
                        {'name': 'All', 'icon': Icons.shopping_bag_outlined},
                        {'name': 'Fashion', 'icon': Icons.checkroom},
                        {'name': 'Electronics', 'icon': Icons.laptop_chromebook},
                        {'name': 'Beauty', 'icon': Icons.face_retouching_natural},
                        {'name': 'Home', 'icon': Icons.chair_outlined},
                      ];
                      
                      return SizedBox(
                        height: 75,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index]['name'] as String;
                            final icon = categories[index]['icon'] as IconData;
                            final isSelected = provider.selectedCategory == category;
                            
                            return GestureDetector(
                              onTap: () => provider.applyFilter(category: category),
                              child: Container(
                                width: 70,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      category == 'All' ? 'For You' : category,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (isSelected)
                                      Container(
                                        height: 3,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      )
                                    else
                                      const SizedBox(height: 3), // Placeholder to prevent jumping
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
              ),
            ),
            
            Expanded(
              child: CustomScrollView(
                slivers: [

                  const SliverToBoxAdapter(child: SizedBox(height: 16)), // Added spacing to move banner down
                  
                  // Old Banner Carousel (HMD Vibe2 style - NO CHANGE)
                  const SliverToBoxAdapter(
                    child: _BannerCarousel(),
                  ),
                  
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  
                  // Product Grid
                  Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      final products = provider.products;
                      if (products.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: Text('No products found.')),
                        );
                      }
                      
                      return SliverPadding(
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
                              return ProductCard(product: products[index]);
                            },
                            childCount: products.length,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % 3;
        });
      }
    });
  }

  List<Map<String, String>> _getBannersForCategory(String category) {
    switch (category) {
      case 'Fashion':
        return [
          {'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80', 'title': 'New Season Trends'},
          {'image': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800&q=80', 'title': 'Winter Collection'},
          {'image': 'https://images.unsplash.com/photo-1485230895905-eb56ba7db3f0?w=800&q=80', 'title': 'Designer Wear 30% Off'},
        ];
      case 'Electronics':
        return [
          {'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=800&q=80', 'title': 'Tech Week - 50% Off'},
          {'image': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&q=80', 'title': 'Latest Smartphones'},
          {'image': 'https://images.unsplash.com/photo-1468495244123-6c6c332eeece?w=800&q=80', 'title': 'Audio & Wearables'},
        ];
      case 'Beauty':
        return [
          {'image': 'https://images.unsplash.com/photo-1596462502278-27bf85033e5a?w=800&q=80', 'title': 'Skincare Essentials'},
          {'image': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80', 'title': 'Makeup Must-Haves'},
          {'image': 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=800&q=80', 'title': 'Organic Beauty Products'},
        ];
      case 'Home':
        return [
          {'image': 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=800&q=80', 'title': 'Modern Home Decor'},
          {'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&q=80', 'title': 'Furniture Sale'},
          {'image': 'https://images.unsplash.com/photo-1583847268964-b28ce8f31586?w=800&q=80', 'title': 'Cozy Living Spaces'},
        ];
      default:
        return [
          {'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800&q=80', 'title': 'Mega Sale 50% Off'},
          {'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80', 'title': 'Fashion New Arrivals'},
          {'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=800&q=80', 'title': 'Tech Week Offers'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = context.watch<ProductProvider>().selectedCategory;
    final banners = _getBannersForCategory(category);
    
    if (_currentIndex >= banners.length) {
      _currentIndex = 0;
    }

    final currentBanner = banners[_currentIndex];
    final bannerImage = currentBanner['image']!;
    final bannerTitle = currentBanner['title']!;

    return Column(
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.05, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<String>(bannerImage),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(bannerImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(20),
                child: Text(
                  bannerTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? AppTheme.primaryColor : AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    var path = Path();
    // Shift up by 6 pixels to be "inside"
    double offset = 6;
    path.moveTo(0, size.height - 30 - offset);
    
    var firstControlPoint = Offset(size.width / 4, size.height - offset);
    var firstEndPoint = Offset(size.width / 2, size.height - 30 - offset);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height - 60 - offset);
    var secondEndPoint = Offset(size.width, size.height - 30 - offset);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
