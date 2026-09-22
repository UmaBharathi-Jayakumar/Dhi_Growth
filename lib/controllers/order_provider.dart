import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../utils/mock_data.dart';
import 'cart_provider.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [
    OrderModel(
      id: 'DG123456',
      items: [
        CartItem(
          id: 'mock_cart_item_1',
          product: MockData.products[0],
          variant: 'M',
          quantity: 2,
        ),
      ],
      totalAmount: MockData.products[0].discountPrice * 2,
      discount: 0,
      deliveryFee: 49,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 1)),
      status: OrderStatus.shipped,
      deliveryAddress: '123 Mock Street, Mock City',
    ),
    OrderModel(
      id: 'DG654321',
      items: [
        CartItem(
          id: 'mock_cart_item_2',
          product: MockData.products[1],
          variant: 'S',
          quantity: 1,
        ),
        CartItem(
          id: 'mock_cart_item_3',
          product: MockData.products[4],
          variant: '',
          quantity: 1,
        ),
      ],
      totalAmount: MockData.products[1].discountPrice + MockData.products[4].discountPrice,
      discount: 100,
      deliveryFee: 0,
      orderDate: DateTime.now().subtract(const Duration(days: 10)),
      expectedDeliveryDate: DateTime.now().subtract(const Duration(days: 5)),
      status: OrderStatus.delivered,
      deliveryAddress: '456 Delivery Avenue, Test Town',
    ),
  ];
  final _uuid = const Uuid();

  List<OrderModel> get orders => _orders;

  void placeOrder(CartProvider cartProvider, String deliveryAddress) {
    if (cartProvider.items.isEmpty) return;

    final newOrder = OrderModel(
      id: 'DG${_uuid.v4().substring(0, 6).toUpperCase()}',
      items: List.from(cartProvider.items), // Copy items
      totalAmount: cartProvider.finalTotal,
      discount: cartProvider.discountAmount,
      deliveryFee: cartProvider.deliveryFee,
      orderDate: DateTime.now(),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 4)),
      status: OrderStatus.placed,
      deliveryAddress: deliveryAddress,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }
}
