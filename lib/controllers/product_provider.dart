import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/mock_data.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = MockData.products;
  List<Product> _filteredProducts = MockData.products;
  List<String> _wishlistIds = [];

  // Filters state
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPriceRange = 'All';
  String _selectedRating = 'All';
  String _sortOption = 'None';

  List<Product> get products => _filteredProducts;
  List<String> get wishlistIds => _wishlistIds;

  String get selectedCategory => _selectedCategory;
  String get selectedPriceRange => _selectedPriceRange;
  String get selectedRating => _selectedRating;
  String get sortOption => _sortOption;
  
  bool isWishlisted(String id) => _wishlistIds.contains(id);

  void toggleWishlist(String id) {
    if (_wishlistIds.contains(id)) {
      _wishlistIds.remove(id);
    } else {
      _wishlistIds.add(id);
    }
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void applyFilter({
    String? category,
    String? priceRange,
    String? rating,
    String? sort,
  }) {
    if (category != null) _selectedCategory = category;
    if (priceRange != null) _selectedPriceRange = priceRange;
    if (rating != null) _selectedRating = rating;
    if (sort != null) _sortOption = sort;
    
    _applyFilters();
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _selectedPriceRange = 'All';
    _selectedRating = 'All';
    _sortOption = 'None';
    _applyFilters();
  }

  int get activeFilterCount {
    int count = 0;
    if (_selectedCategory != 'All') count++;
    if (_selectedPriceRange != 'All') count++;
    if (_selectedRating != 'All') count++;
    if (_sortOption != 'None') count++;
    return count;
  }

  void _applyFilters() {
    List<Product> result = _allProducts;

    // Search
    if (_searchQuery.isNotEmpty) {
      result = result.where((p) => 
        p.name.toLowerCase().contains(_searchQuery) || 
        p.category.toLowerCase().contains(_searchQuery)
      ).toList();
    }

    // Category
    if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    // Price Range
    if (_selectedPriceRange != 'All') {
      if (_selectedPriceRange == 'Under ₹500') {
        result = result.where((p) => p.discountPrice < 500).toList();
      } else if (_selectedPriceRange == '₹500-₹1000') {
        result = result.where((p) => p.discountPrice >= 500 && p.discountPrice <= 1000).toList();
      } else if (_selectedPriceRange == '₹1000-₹2000') {
        result = result.where((p) => p.discountPrice > 1000 && p.discountPrice <= 2000).toList();
      } else if (_selectedPriceRange == 'Above ₹2000') {
        result = result.where((p) => p.discountPrice > 2000).toList();
      }
    }

    // Rating
    if (_selectedRating != 'All') {
      if (_selectedRating == '4★ & above') {
        result = result.where((p) => p.rating >= 4.0).toList();
      } else if (_selectedRating == '3★ & above') {
        result = result.where((p) => p.rating >= 3.0).toList();
      }
    }

    // Sort
    if (_sortOption != 'None') {
      if (_sortOption == 'Price: Low to High') {
        result.sort((a, b) => a.discountPrice.compareTo(b.discountPrice));
      } else if (_sortOption == 'Price: High to Low') {
        result.sort((a, b) => b.discountPrice.compareTo(a.discountPrice));
      } else if (_sortOption == 'Rating') {
        result.sort((a, b) => b.rating.compareTo(a.rating));
      }
    }

    _filteredProducts = result;
    notifyListeners();
  }
}
