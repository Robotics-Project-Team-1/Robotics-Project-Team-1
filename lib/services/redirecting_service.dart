import 'package:project2/components/loading.dart';
import 'package:project2/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:project2/pages/login.dart';
import 'package:project2/services/authService.dart';

class RedirectingService extends StatelessWidget {
  const RedirectingService({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    return Scaffold(
      body: StreamBuilder(
        stream: auth.getAuthentication().authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
