import 'package:project2/firebase_options.dart';
import 'package:project2/providers/food.dart';
import 'package:project2/services/redirecting_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FoodMethods()),
    ],
    child: const FoodDeliveryApp(),
  ));
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RedirectingService(),
    );
  }
}
