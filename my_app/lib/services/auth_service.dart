import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. REGISTER FUNCTION
  Future<User?> registerUser(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      // Save their role (Driver or Passenger) so the app knows who they are later
      await _db.collection('users').doc(result.user!.uid).set({
        'email': email,
        'role': role, 
        'uid': result.user!.uid,
      });
      return result.user;
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }

  // 2. LOGIN FUNCTION
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }
}