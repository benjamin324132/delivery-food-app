import 'package:flutter/material.dart';
import 'dart:collection';

//70 + 250 + 360
class AppProvider extends ChangeNotifier {
  final List<dynamic> _items = [
    /*{
      "name": "Steak Taco",
      "image":
          "https://cdn.dribbble.com/userupload/2671447/file/original-e44b3cd5a3e697f1c2fc9f358e9425d8.jpg",
      "price": 35,
      "qty": 2,
      "coments": "",
      "dishId": "627d63fa88176d101178fa74"
    },
    {
      "name": "Pzza",
      "image":
          "https://cdn.dribbble.com/userupload/2713951/file/original-a0fa3b862cde83133a27613b78be2a34.png",
      "price": 250,
      "qty": 1,
      "coments": "",
      "dishId": "627d644588176d101178fa77"
    },
    {
      "name": "Hamburguer",
      "image":
          "https://cdn.dribbble.com/userupload/2713953/file/original-f85abe94e5b7582667e36bfff0e537a3.png",
      "price": 120,
      "qty": 3,
      "coments": "",
      "dishId": "627d648688176d101178fa7a"
    }*/
  ];
  bool isLogged = false;

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<dynamic> get items => UnmodifiableListView(_items);
  //UnmodifiableListView<dynamic> get messages => UnmodifiableListView(_messages);

  int totalCart() {
    int sum = 0;
    if (_items.isNotEmpty) {
      sum = _items
          .map<int>((m) => (m["price"] * m["qty"]))
          .reduce((a, b) => a + b);
    } else {
      sum = 0;
    }
    return sum;
  }

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(item) {
    _items.add(item);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeItem(index) {
    _items.removeAt(index);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void handleAuth(auth) {
    isLogged = auth;
    notifyListeners();
  }
}
