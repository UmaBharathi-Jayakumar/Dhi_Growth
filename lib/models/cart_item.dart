import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  String variant; // e.g., size
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.variant,
    this.quantity = 1,
  });
}
