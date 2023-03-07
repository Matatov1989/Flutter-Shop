import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order_item.dart';

class Orders with ChangeNotifier {
  final List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders.toList();

  void addOrder(List<CartItemModel> cartProducts, double total) {
    _orders.insert(0, OrderModel(id: DateTime.now().toString(), amount: total, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }
}
