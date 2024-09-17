import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project2/components/alert_dialog.dart';
import 'package:project2/components/button.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/components/update_profile.dart';
import 'package:project2/services/authService.dart';
import 'package:project2/services/databaseService.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  bool _isLoading = true;
  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _oldPassword;
  final TextEditingController _updateFirstName = TextEditingController();
  final TextEditingController _updateLastName = TextEditingController();
  final TextEditingController _updatePassword = TextEditingController();
  final TextEditingController _updateConfirmPassword = TextEditingController();

  void getInfo() async {
    try {
      _firstName = await _db.getUserInfo(_auth.getCurrentUserUID, "fname");
      _lastName = await _db.getUserInfo(_auth.getCurrentUserUID, "lname");
      _email = await _db.getUserInfo(_auth.getCurrentUserUID, "email");
      _oldPassword = await _db.getUserInfo(_auth.getCurrentUserUID, "password");
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserLogin() async {
    if (_updateFirstName.text.isEmpty &&
        _updateLastName.text.isEmpty &&
        _updatePassword.text.isEmpty) {
      return;
    }
    final String newFirstName = _updateFirstName.text;
    final String newLastName = _updateLastName.text;
    final String newPassword = _updatePassword.text;
    final String newConfirmPass = _updateConfirmPassword.text;
    try {
      DocumentReference docRef =
          _db.getDocRef("users", _auth.getCurrentUserUID);
      if (newFirstName.isNotEmpty) {
        await docRef.update({"fname": newFirstName});
      }
      if (newLastName.isNotEmpty) {
        await docRef.update({"lname": newLastName});
      }
      if (newPassword.isNotEmpty &&
          newPassword.length >= 6 &&
          newPassword == newConfirmPass) {
        AuthCredential cred =
            EmailAuthProvider.credential(email: _email, password: _oldPassword);
        await _auth.getCurrentUser!.reauthenticateWithCredential(cred);
        await _auth.getCurrentUser!.updatePassword(newPassword);
        await docRef.update({"password": newPassword});
      }
      return;
    } on FirebaseException catch (e) {
      return showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => MyAlertDialog(
          title: "Error",
          content: e.toString(),
        ),
      );
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    _updateFirstName.dispose();
    _updateLastName.dispose();
    _updatePassword.dispose();
    _updateConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[600],
        title: Text("Update Profile".toUpperCase()),
        centerTitle: true,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'lib/images/login-profile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.grey, height: 40),
                      Column(
                        children: [
                          UpdateProfileField(
                            controller: _updateFirstName,
                            keyboard: TextInputType.name,
                            textHint: "Enter new first name",
                            textboxHint: "Change First Name",
                          ),
                          UpdateProfileField(
                            controller: _updateLastName,
                            keyboard: TextInputType.name,
                            textHint: "Enter new last name",
                            textboxHint: "Change Last Name",
                          ),
                          UpdateProfileField(
                            controller: _updatePassword,
                            keyboard: TextInputType.visiblePassword,
                            textHint: "Enter new password",
                            textboxHint: "Change password",
                          ),
                          UpdateProfileField(
                            controller: _updateConfirmPassword,
                            keyboard: TextInputType.visiblePassword,
                            textHint: "Confirm new password",
                            textboxHint: "Confirm password",
                          ),
                          const SizedBox(height: 40),
                          MyButton(
                            title: "Update Information",
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const LoadingWidget(),
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              updateUserLogin();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context, rootNavigator: true).pop();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
