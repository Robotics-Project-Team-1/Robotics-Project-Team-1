import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  Future<void> saveOrderToDatabase(String receipt) async {
    await orders.add({
      'data': DateTime.now(),
      'order': receipt,
    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore getDatabase() {
    return _db;
  }

  CollectionReference getDBCollection(String collection) {
    return _db.collection(collection);
  }

  DocumentReference getDocRef(String collection, String userID) {
    return _db.collection(collection).doc(userID);
  }

  Future<void> dbUserRegister(
      Map<String, dynamic> userinfo, String currentUserID) async {
    CollectionReference db = _db.collection("users");
    await db.doc(currentUserID).set({
      "fname": userinfo["fname"],
      "lname": userinfo["lname"],
      "email": userinfo["email"],
      "password": userinfo["password"],
      "time": userinfo["timestamp"],
      "id": userinfo["id"],
    }, SetOptions(merge: true));
  }

  Future<String> getUserInfo(String userID, String info) async {
    DocumentReference docRef = _db.collection("users").doc(userID);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data[info];
  }

  Future<Map<String, dynamic>> getAllUserInfo(String userID) async {
    DocumentReference docRef = _db.collection("users").doc(userID);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data;
  }
}
