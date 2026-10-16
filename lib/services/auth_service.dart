import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<String?> registrar({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );
      await _db.collection('usuarios').doc(cred.user!.uid).set({
        'nombre': nombre,
        'correo': correo,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(String correo, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: correo,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}