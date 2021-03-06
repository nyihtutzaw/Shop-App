import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cart) {
      total += cart.quantity * cart.price;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                quantity: 1,
                price: price,
                title: title,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeCurrentlyAddedItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else {
      if (_items[productId].quantity > 1) {
        _items.update(
            productId,
            (prev) => CartItem(
                  id: prev.id,
                  price: prev.price,
                  quantity: prev.quantity - 1,
                  title: prev.title,
                ));
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }
}
