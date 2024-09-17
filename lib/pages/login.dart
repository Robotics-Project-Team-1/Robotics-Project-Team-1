import 'package:firebase_auth/firebase_auth.dart';
import 'package:project2/components/button.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/components/textformfield.dart';
import 'package:project2/pages/register.dart';
import 'package:project2/services/authService.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = true;

  void login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    try {
      await _auth.authUserLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      return showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: e.code == "invalid-email"
              ? const Text("Invalid Email")
              : const Text("Invalid Password"),
        ),
      );
    }
  }

  void clearInputField() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Food Delivery App".toUpperCase(),
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Login".toUpperCase(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'lib/images/LogoColored.png',
                    ),
                  ),
                  const Text(
                    'Welcome Back Customer!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            controller: _emailController,
                            isObscure: false,
                            label: "Email",
                          ),
                          const SizedBox(height: 16),
                          MyTextFormField(
                            controller: _passwordController,
                            isObscure: true,
                            label: "Password",
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "New User? ",
                                style: TextStyle(fontSize: 14),
                              ),
                              InkWell(
                                onTap: () => {
                                  clearInputField(),
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  )),
                                },
                                child: Text(
                                  "Register Here!",
                                  style: TextStyle(
                                      color: Colors.blue[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          MyButton(
                            title: "Login",
                            onTap: login,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
