import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth getAuthentication() {
    return _auth;
  }

  User? get getCurrentUser => _auth.currentUser;

  String get getCurrentUserUID => _auth.currentUser!.uid;

  Future<void> authUserRegister(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> authUserLogin(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    return await _auth.signOut();
  }
}
