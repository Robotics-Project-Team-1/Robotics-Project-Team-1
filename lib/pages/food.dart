import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project2/components/button.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/models/food.dart';
import 'package:project2/providers/food.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({
    super.key,
    required this.menu,
  });

  final Food menu;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Future<void> addToCart(Food food) async {
    Navigator.pop(context);
    context.read<FoodMethods>().addToCart(food);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Image.asset(
                          widget.menu.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 0,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          // iconSize: 40,
                          icon: const Icon(
                            Icons.arrow_circle_left,
                            size: 40,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.menu.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                widget.menu.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        MyButton(
                          title: "Add to cart",
                          onTap: () => addToCart(widget.menu),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
