import 'package:flutter/material.dart';

class MyTrackingBox extends StatelessWidget {
  const MyTrackingBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumnSection(
                '\$3.99',
                'Delivery Fee',
                const TextStyle(
                  color: Colors.teal,
                  fontFamily: 'Georgia',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Courier',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              _buildColumnSection(
                '15-20 min',
                'Delivery Time',
                const TextStyle(
                  color: Colors.teal,
                  fontFamily: 'Georgia',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Courier',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          _buildDeliveryIcon(),
        ],
      ),
    );
  }

  Widget _buildColumnSection(
      String title,
      String subtitle,
      TextStyle titleStyle,
      TextStyle subtitleStyle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 5),
        Text(subtitle, style: subtitleStyle),
      ],
    );
  }

  Widget _buildDeliveryIcon() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.shade100,
      ),
      child: Icon(
        Icons.delivery_dining,
        color: Colors.teal,
        size: 80,
      ),
    );
  }
}