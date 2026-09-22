import 'cart_item.dart';

enum OrderStatus { placed, confirmed, packed, shipped, outForDelivery, delivered }

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final double discount;
  final double deliveryFee;
  final DateTime orderDate;
  final DateTime expectedDeliveryDate;
  final OrderStatus status;
  final String deliveryAddress;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.discount,
    required this.deliveryFee,
    required this.orderDate,
    required this.expectedDeliveryDate,
    this.status = OrderStatus.placed,
    required this.deliveryAddress,
  });
}
