import 'package:flutter/material.dart';

class MySettingWidget extends StatelessWidget {
  const MySettingWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.circle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color circle;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: circle,
              radius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
