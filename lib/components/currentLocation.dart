import 'package:project2/providers/food.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCurrentLocation extends StatelessWidget {
  const MyCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    void openLocationSearchBox(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Your Location',
            style: TextStyle(
              color: Colors.teal,
              fontFamily: 'Georgia',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Address",
              hintStyle: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'Courier',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            MaterialButton(
              onPressed: () {
                String newAddress = textController.text;
                Provider.of<FoodMethods>(context, listen: false)
                    .updateDeliveryAddress(newAddress);
                Navigator.pop(context);
                textController.clear();
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
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
            'Delivery to',
            style: TextStyle(
              color: Colors.teal,
              fontFamily: 'Georgia',
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Consumer<FoodMethods>(
                    builder: (context, restaurant, child) => Text(
                      restaurant.deliveryAddress,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: 'Courier',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}