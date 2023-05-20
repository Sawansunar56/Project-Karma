import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final UserCredential currentUser =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.user?.uid)
        .set({
      "email": email,
      "name": fullName,
      "phone": phone,
      "pass": password,
      "uid": currentUser.user?.uid,
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
