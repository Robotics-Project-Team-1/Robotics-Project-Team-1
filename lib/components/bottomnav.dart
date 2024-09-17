import 'package:flutter/material.dart';
import 'package:project2/pages/home.dart';
import 'package:project2/pages/setting.dart';
import 'package:project2/pages/track.dart';
import 'package:project2/pages/cart.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue[600],
      onTap: (index) {
        if (currentIndex == index) {
          return;
        }
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TrackPage()),
          );
        }

        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        }

        if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: "Track",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Setting",
        ),
      ],
    );
  }
}
