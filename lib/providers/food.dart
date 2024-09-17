import 'package:project2/models/cartitem.dart';
import 'package:project2/models/food.dart';
import 'package:project2/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodMethods extends ChangeNotifier {
  final Restaurant _restaurant = Restaurant();
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  List<Food> get vietMenu => _restaurant.allFood["viet"];
  List<Food> get koreanMenu => _restaurant.allFood["korean"];
  List<Food> get spanishMenu => _restaurant.allFood["spanish"];
  List<Food> get italianMenu => _restaurant.allFood["italian"];
  List<Food> get americanMenu => _restaurant.allFood["american"];

  String _deliveryAddress = "123 Flint Drive, Atlanta, Georgia 30303";
  String get deliveryAddress => _deliveryAddress;

  final receipt = StringBuffer();

  int get foodCount => _restaurant.allFood.length;
  List<String> get allFoodKey {
    return _restaurant.allFood.keys.toList();
  }

  List<List<Food>> get allFoodItems {
    return _restaurant.allFood.values.map((e) => e as List<Food>).toList();
  }

  void addToCart(Food food) {
    CartItem? cartItem;
    try {
      cartItem = _cart.firstWhere((item) => item.food == food);
    } catch (e) {
      cartItem = null;
    }

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(
        CartItem(food: food),
      );
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Food Delivery App");
    receipt.writeln("427 Holcomb Bridge, Atlanta, GA 30022");
    receipt.writeln("(470) 123-987");
    receipt.writeln();

    String formattedDate =
    DateFormat('yyyy-mm-dd hh:mm:ss').format(DateTime.now());
    receipt.writeln("Date: $formattedDate");
    receipt.writeln("Customer: Mira Jane");
    receipt.writeln("Ticket#: 120");
    receipt.writeln();

    receipt.writeln(
        "--------------------------------------------------------------");
    receipt.writeln(
        "--------------------------------------------------------------");
    receipt.writeln();

    for (final cartItem in _cart) {
      receipt.writeln(
          "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      receipt.writeln();
    }
    receipt.writeln(
        "--------------------------------------------------------------");
    receipt.writeln(
        "--------------------------------------------------------------");
    receipt.writeln();

    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();

    receipt.writeln("Delivering to: $deliveryAddress");
    receipt.writeln();

    receipt.writeln("PAYMENT DETAILS");
    receipt.writeln("DISCOVER - 1919               ${_formatPrice(getTotalPrice())}");
    receipt.writeln();

    receipt.writeln("All Services are Final");
    receipt.writeln("No Refund; Corrections Only");
    receipt.writeln("Call us if you have any questions");
    receipt.writeln("THANK YOU!");
    receipt.writeln();

    return receipt.toString();
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;
      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

}
