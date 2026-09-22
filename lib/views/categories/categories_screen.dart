import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const CategoriesScreen({super.key, this.onBackPressed});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'For You', 'image': 'https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=200&q=80'},
    {'name': 'Fashion', 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200&q=80'},
    {'name': 'Mobiles', 'image': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200&q=80'},
    {'name': 'Appliances', 'image': 'https://images.unsplash.com/photo-1626806787426-5910811b6325?w=200&q=80'},
    {'name': 'Electronics', 'image': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=200&q=80'},
    {'name': 'Smart Gadgets', 'image': 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200&q=80'},
    {'name': 'Home', 'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200&q=80'},
    {'name': 'Beauty', 'image': 'https://images.unsplash.com/photo-1596462502278-27bf85033e5a?w=200&q=80'},
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
        title: const Text(
          'All Categories', 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar (Navigation Rail style)
          Container(
            width: 85,
            color: const Color(0xFFF0F2F5), // Light grayish blue background
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategoryIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: isSelected 
                          ? Border(left: BorderSide(color: Colors.blue[700]!, width: 4))
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: category['image'],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              width: 48,
                              height: 48,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              width: 48,
                              height: 48,
                              child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.blue[800] : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Right Content Area
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildCategoryContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent() {
    // We simulate the content shown in the screenshot using real images
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Popular Store',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75, // Adjust for image + text
          children: [
            _buildGridItem('Starts 9th Oct', 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=200&q=80'),
            _buildGridItem('Starts 24th Sept', 'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=200&q=80'),
            _buildGridItem('Value 365', 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200&q=80'),
            _buildGridItem('Minutes', 'https://images.unsplash.com/photo-1526367790999-0150786686a2?w=200&q=80'), // delivery/scooter
            _buildGridItem('Sneakers', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200&q=80'),
            _buildGridItem('Trains', 'https://images.unsplash.com/photo-1471506480208-91b3a4cc78be?w=200&q=80'),
            _buildGridItem('Grocery', 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200&q=80'),
          ],
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'New & Upcoming Launches',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
          children: [
            _buildLaunchItem('Coming soon', 'TVS Jupiter', 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=200&q=80', Colors.pink[50]!),
            _buildLaunchItem('Coming soon', 'TVS NTORQ', 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=200&q=80', Colors.purple[50]!),
            _buildLaunchItem('BUY NOW', 'iPhone 18 Pro', 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=200&q=80', Colors.grey[200]!, buttonColor: Colors.teal),
            _buildLaunchItem('BUY NOW', 'Xiaomi 65"', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=200&q=80', Colors.black87, buttonColor: Colors.teal, textColor: Colors.white),
            _buildLaunchItem('BUY NOW', 'boltt EVO', 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200&q=80', Colors.blue[50]!, buttonColor: Colors.teal),
            _buildLaunchItem('NOTIFY ME', 'boltt ACE', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=200&q=80', Colors.grey[300]!, buttonColor: Colors.teal),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(String title, String imageUrl) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLaunchItem(String buttonText, String title, String imageUrl, Color bgColor, {Color buttonColor = Colors.transparent, Color textColor = Colors.black87}) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: bgColor),
                  errorWidget: (context, url, error) => Container(color: bgColor, child: const Icon(Icons.broken_image)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (buttonColor != Colors.transparent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          )
        else
          Text(
            buttonText,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
      ],
    );
  }
}
