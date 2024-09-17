import 'package:flutter/material.dart';
import 'package:project2/models/food.dart';
import 'package:project2/pages/food.dart';

class TabItems extends StatelessWidget {
  const TabItems({
    super.key,
    required this.menu,
  });

  final List<Food> menu;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final food = menu[index];
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FoodPage(menu: food)),
                ),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        food.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(food.description),
                          ),
                          Text(
                            "\$${food.price}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
