import 'package:flutter/material.dart';
import 'package:project2/services/databaseService.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/providers/food.dart';
import 'package:project2/components/mycheckout.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
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
        title: Text("Checkout".toUpperCase()),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
        child: Column(
          children: [
            MyCheckout(),
          ],
        ),
      ),
    );
  }
}