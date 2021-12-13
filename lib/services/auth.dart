import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:neighborhood_stores_app/models/user.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerWithEmailAndPassword(UserData userData) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userData.email ?? '', password: userData.password ?? '');
      User? user = userCredential.user;

      await DatabaseService(userId: user!.uid).updateUserData(UserData(
          name: userData.name,
          address: userData.address,
          landline: userData.landline,
          cellphone: userData.cellphone));

      return user;

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      return user;

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  User? getCurrentUser() {
    try {
      return _auth.currentUser;

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future deleteUser() async {
    try {
      return _auth.currentUser!.delete();

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
