import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project2/components/display_box.dart';
import 'package:project2/components/loading.dart';
import 'package:project2/services/authService.dart';
import 'package:project2/services/databaseService.dart';

class DisplayUserPage extends StatefulWidget {
  const DisplayUserPage({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  State<DisplayUserPage> createState() => _DisplayUserPageState();
}

class _DisplayUserPageState extends State<DisplayUserPage> {
  bool _isLoading = true;
  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();

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
        title: Text("User Info".toUpperCase()),
        centerTitle: true,
        elevation: 4,
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
                              "User Information",
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
                            DisplayWidget(
                              title: "First Name: ${widget.data["fname"]}",
                              circle: Colors.red,
                            ),
                            DisplayWidget(
                              title: "Last Name: ${widget.data["lname"]}",
                              circle: Colors.green,
                            ),
                            DisplayWidget(
                              title: "Email: ${widget.data["email"]}",
                              circle: Colors.blue,
                            ),
                            DisplayWidget(
                              title: "Password: ${widget.data["password"]}",
                              circle: Colors.yellow,
                            ),
                            DisplayWidget(
                              title:
                                  "Creation date: ${DateFormat.yMMMd().format(widget.data["time"].toDate())}",
                              circle: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
