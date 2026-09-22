import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/gradient_button.dart';

import '../../controllers/product_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<ProductProvider>().search('');
                },
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              context.read<ProductProvider>().search(value);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter & Sort Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      '${provider.products.length} Results',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 20),
                      const SizedBox(width: 4),
                      const Text('Filter & Sort', style: TextStyle(fontWeight: FontWeight.bold)),
                      Consumer<ProductProvider>(
                        builder: (context, provider, child) {
                          if (provider.activeFilterCount > 0) {
                            return Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${provider.activeFilterCount}',
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final products = provider.products;
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No products found for "${_searchController.text}"',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> categories = ['All', 'Fashion', 'Electronics', 'Beauty', 'Home'];
  final List<String> priceRanges = ['All', 'Under ₹500', '₹500-₹1000', '₹1000-₹2000', 'Above ₹2000'];
  final List<String> ratings = ['All', '4★ & above', '3★ & above'];
  final List<String> sortOptions = ['None', 'Price: Low to High', 'Price: High to Low', 'Rating'];

  late String selectedCategory;
  late String selectedPriceRange;
  late String selectedRating;
  late String selectedSortOption;
  
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Category', 'Price', 'Rating', 'Sort By'];

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    selectedCategory = provider.selectedCategory;
    selectedPriceRange = provider.selectedPriceRange;
    selectedRating = provider.selectedRating;
    selectedSortOption = provider.sortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle notch
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters & Sort', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar
                Container(
                  width: 140,
                  color: const Color(0xFFF9F9F9),
                  child: ListView.builder(
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedTabIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Right Content
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: ListView(
                        key: ValueKey<int>(_selectedTabIndex),
                        padding: const EdgeInsets.all(20.0),
                        children: [
                          Text(
                            'Select ${_tabs[_selectedTabIndex]}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._buildOptionsForCurrentTab(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(0, -6),
                  blurRadius: 12,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () {
                        context.read<ProductProvider>().clearFilters();
                        Navigator.pop(context);
                      },
                      child: Text('Clear All', style: TextStyle(color: Colors.grey.shade800)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: GradientButton(
                      onPressed: () {
                        context.read<ProductProvider>().applyFilter(
                          category: selectedCategory,
                          priceRange: selectedPriceRange,
                          rating: selectedRating,
                          sort: selectedSortOption,
                        );
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      borderRadius: 12,
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptionsForCurrentTab() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildRadioList(categories, selectedCategory, (val) => setState(() => selectedCategory = val));
      case 1:
        return _buildRadioList(priceRanges, selectedPriceRange, (val) => setState(() => selectedPriceRange = val));
      case 2:
        return _buildRadioList(ratings, selectedRating, (val) => setState(() => selectedRating = val));
      case 3:
        return _buildRadioList(sortOptions, selectedSortOption, (val) => setState(() => selectedSortOption = val));
      default:
        return [];
    }
  }

  List<Widget> _buildRadioList(List<String> options, String selectedValue, Function(String) onSelected) {
    return options.map((option) {
      final isSelected = selectedValue == option;
      return GestureDetector(
        onTap: () => onSelected(option),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey.shade400,
                    width: isSelected ? 6 : 2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 15,
                    color: isSelected ? AppTheme.textPrimary : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}


