import 'package:my_shop/models/cart_item.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime dateTime;

  OrderModel({required this.id, required this.amount, required this.products, required this.dateTime});
}
