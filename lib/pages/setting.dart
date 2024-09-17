import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/components/setting_button.dart';
import 'package:project2/components/bottomnav.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/pages/display_user.dart';
import 'package:project2/pages/updateprofile.dart';
import 'package:project2/services/authService.dart';
import 'package:project2/services/databaseService.dart';
import 'package:project2/services/redirecting_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isLoading = true;
  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();
  late Map<String, dynamic> _data;

  Future getAllUserData() async {
    try {
      _data = await _db.getAllUserInfo(_auth.getCurrentUserUID);
      return;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        title: Text("Setting".toUpperCase()),
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.grey,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'lib/images/login-profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Account Setting",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            const Divider(
                              indent: 0,
                              endIndent: 0,
                              height: 20,
                            ),
                            const SizedBox(height: 10),

                            // Display user information
                            MySettingWidget(
                              title: "User Information",
                              subtitle: "See current user information",
                              circle: Colors.black,
                              onTap: () async {
                                await getAllUserData();
                                // ignore: use_build_context_synchronously
                                await Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => DisplayUserPage(
                                          data: _data,
                                        ),
                                      ),
                                    )
                                    .then((_) => setState(() {}));
                              },
                            ),
                            const SizedBox(height: 20),

                            // Manage account
                            MySettingWidget(
                              title: "Manage Acccount",
                              subtitle: "Update account informations",
                              circle: Colors.blue,
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UpdateProfilePage(),
                                      ),
                                    )
                                    .then((_) => setState(() {
                                          getAllUserData();
                                        }));
                              },
                            ),
                            const SizedBox(height: 140),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      _auth.logout();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RedirectingService()),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Logout".toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.logout),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const MyBottomNavBar(currentIndex: 3),
    );
  }
}
