import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project2/components/alert_dialog.dart';
import 'package:project2/components/button.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/components/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:project2/services/authService.dart';
import 'package:project2/services/databaseService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameControler = TextEditingController();
  final TextEditingController _lastNameControler = TextEditingController();
  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();
  bool _isLoading = true;

  void register() async {
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text.trim() !=
        _confirmpasswordController.text.trim()) {
      return showDialog(
        context: context,
        builder: (context) => const MyAlertDialog(
            title: "Error!",
            content:
                "Please ensure the password and the confirmed password are matched!"),
      );
    }
    try {
      // Register user with auth service
      await _auth.authUserRegister(
        _emailController.text,
        _passwordController.text,
      );

      // Register user to database
      Map<String, dynamic> user = {
        "fname": _firstNameControler.text,
        "lname": _lastNameControler.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "timestamp": Timestamp.now(),
        "id": _auth.getCurrentUserUID,
      };
      await _db.dbUserRegister(user, _auth.getCurrentUserUID);
    } on FirebaseException catch (e) {
      return showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => MyAlertDialog(
            title: "Error!",
            content: "Unable to register, please try again ${e.toString()}"),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameControler.dispose();
    _lastNameControler.dispose();
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
        title: Text("Registration".toUpperCase()),
        centerTitle: true,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'lib/images/LogoColored.png',
                    ),
                  ),
                  const Text(
                    'Welcome New Customer!',
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
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: MyTextFormField(
                                  controller: _firstNameControler,
                                  isObscure: false,
                                  label: "First Name",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MyTextFormField(
                                  controller: _lastNameControler,
                                  isObscure: false,
                                  label: "Last Name",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                          MyTextFormField(
                            controller: _confirmpasswordController,
                            isObscure: true,
                            label: "Confirm Password",
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Returning User? ",
                                style: TextStyle(fontSize: 14),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Login Here!",
                                  style: TextStyle(
                                      color: Colors.blue[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          MyButton(
                            title: "Register",
                            onTap: () => {
                              register(),
                              setState(() {
                                Navigator.of(context).pop();
                              }),
                            },
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
