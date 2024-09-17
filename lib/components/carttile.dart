import 'package:project2/components/quantityselector.dart';
import 'package:project2/models/cartitem.dart';
import 'package:project2/providers/food.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodMethods>(
      builder: (context, restaurant, child) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    cartItem.food.imagePath,
                    height: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 11.0, bottom: 8, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItem.food.name),
                      Text("\$${cartItem.food.price}"),
                      SizedBox(
                        height: 10,
                      ),
                      MyQuantitySelector(
                        quantity: cartItem.quantity,
                        food: cartItem.food,
                        onIncrement: () {
                          restaurant.addToCart(
                              cartItem.food);
                        },
                        onDecrement: () {
                          restaurant.removeFromCart(cartItem);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
