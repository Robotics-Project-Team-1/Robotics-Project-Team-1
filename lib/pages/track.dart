import 'package:flutter/material.dart';
import 'package:project2/services/databaseService.dart';
import 'package:project2/components/bottomnav.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/providers/food.dart';
import 'package:project2/components/currentlocation.dart';
import 'package:project2/components/trackingbox.dart';
import 'package:project2/components/button.dart';
import 'package:project2/pages/checkout.dart';
import 'package:project2/pages/cart.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  FirestoreService db = FirestoreService();
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    final foodMethods = FoodMethods();
    String receipt = foodMethods.displayCartReceipt();
    db.saveOrderToDatabase(receipt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        title: Text("Track".toUpperCase()),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Column(
        children: [
          MyCurrentLocation(),
          MyTrackingBox(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Thank you for your order!",
                  style: TextStyle(
                    color: Colors.teal,
                    fontFamily: 'Georgia',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      title: "Cart",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                    ),
                    MyButton(
                      title: "Receipt",
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomNavBar(currentIndex: 1),
    );
  }
}