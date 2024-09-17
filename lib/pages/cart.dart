import 'package:project2/providers/food.dart';
import 'package:project2/components/bottomnav.dart';
import 'package:project2/components/carttile.dart';
import 'package:project2/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:project2/pages/checkout.dart';
import 'package:provider/provider.dart';
import 'package:project2/components/button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<FoodMethods>(builder: (context, restaurant, child) {
      final userCart = restaurant.cart;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          title: Text("Cart".toUpperCase()),
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.grey,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Are you sure you want to clear the cart?",
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            restaurant.clearCart();
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ));
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        body: _isLoading
            ? const LoadingWidget()
            : Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  userCart.isEmpty
                      ? Expanded(
                    child: Center(
                      child: Text(
                        "Cart is empty",
                        style: TextStyle(
                            color:
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  )
                      : Expanded(
                    child: ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          final cartItem = userCart[index];
                          return MyCartTile(cartItem: cartItem);
                        }),
                  ),
                  const SizedBox(height: 40),
                  MyButton(
                    title: "Checkout",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MyBottomNavBar(currentIndex: 2),
      );

    });
  }
}