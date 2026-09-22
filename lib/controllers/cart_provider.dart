import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final _uuid = const Uuid();

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get productTotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  double get discountAmount {
    double totalDiscount = 0.0;
    for (var item in _items) {
      double discountPerItem = item.product.price - item.product.discountPrice;
      totalDiscount += discountPerItem * item.quantity;
    }
    return totalDiscount;
  }

  double get deliveryFee => productTotal > 0 ? 40.0 : 0.0;

  double get finalTotal => productTotal - discountAmount + deliveryFee;

  void addToCart(Product product, String variant, int quantity) {
    // Check if item with same variant already exists
    final index = _items.indexWhere((item) => item.product.id == product.id && item.variant == variant);
    
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: _uuid.v4(),
        product: product,
        variant: variant,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void incrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void updateVariant(String id, String newVariant) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].variant = newVariant;
      notifyListeners();
    }
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0 && newQuantity > 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void decrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
