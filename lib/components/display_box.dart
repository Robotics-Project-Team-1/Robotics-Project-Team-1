import 'package:flutter/material.dart';

class DisplayWidget extends StatelessWidget {
  const DisplayWidget({
    super.key,
    required this.title,
    required this.circle,
  });

  final String title;
  final Color circle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              CircleAvatar(
                backgroundColor: circle,
                radius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
