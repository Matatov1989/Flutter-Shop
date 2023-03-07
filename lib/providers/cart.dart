import 'package:flutter/foundation.dart';
import 'package:my_shop/models/cart_item.dart';

class Cart extends ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartId) => CartItemModel(id: existingCartId.id, title: existingCartId.title, quantity: existingCartId.quantity, price: existingCartId.price + 1),
      );
    } else {
      _items.putIfAbsent(productId, () => CartItemModel(id: DateTime.now().toString(), title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (existingCartItem) => CartItemModel(id: existingCartItem.id, title: existingCartItem.title, quantity: existingCartItem.quantity, price: existingCartItem.price - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
